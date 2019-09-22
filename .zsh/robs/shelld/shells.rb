#!/usr/bin/env ruby

dir = "#{ENV['HOME']}/.shelld/shells"

pids = `pgrep -U${USER} zsh`.split.sort
pid_dirs = `ls #{dir}`.split.sort

old_pids = pid_dirs - pids
new_pids = pids - pid_dirs

def remove_old_dirs(old_pids, dir)
  dirs = old_pids.map { |d| File.join(dir, d) }.join(' ')
  return if dirs.empty?
  puts `rm -vr #{dirs}`
end

def create_new_dirs(new_pids, dir)
  dirs = new_pids.map { |d| File.join(dir, d) }.join(' ')
  return if dirs.empty?
  puts `mkdir -vp #{dirs}`
end

def update_pid_dirs(pids, dir)
  pids.each do |pid|
    pid_cwd = `readlink -e /proc/#{pid}/cwd`
    File.write("#{dir}/#{pid}/cwd", pid_cwd)
  end
end

scripts = Dir.glob("#{ENV['HOME']}/.zsh/robs/shelld/scripts/*")

def run_scripts(pids, scripts, dir)
  pids.each do |pid|
    scripts.each do |script|
      #cwd_file = "#{dir}/#{pid}/cwd"
      output = `#{script} #{pid}`
      next if output.empty?
      puts output
    end
  end
end

remove_old_dirs(old_pids, dir)
create_new_dirs(new_pids, dir)
update_pid_dirs(pids, dir)
run_scripts(pids, scripts, dir)
