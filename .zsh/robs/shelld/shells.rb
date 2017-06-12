#!/usr/bin/env ruby

dir = "#{ENV['HOME']}/.shelld"

pids = `pgrep -U${USER} zsh`.split.sort
pid_dirs = `ls ${HOME}/.shelld/`.split.sort

old_pids = pid_dirs - pids
new_pids = pids - pid_dirs

def remove_old_dirs(old_pids)
  dirs = old_pids.map { |d| File.join("#{ENV['HOME']}/.shelld", d) }.join(' ')
  return if dirs.empty?
  puts `rm -vr #{dirs}`
end

def create_new_dirs(new_pids)
  dirs = new_pids.map { |d| File.join("#{ENV['HOME']}/.shelld", d) }.join(' ')
  return if dirs.empty?
  puts `mkdir -vp #{dirs}`
end

def update_pid_dirs(pids)
  pids.each do |pid|
    pid_cwd = `readlink -e /proc/#{pid}/cwd`
    File.write("#{ENV['HOME']}/.shelld/#{pid}/cwd", pid_cwd)
  end
end

scripts = Dir.glob("/home/rw/.zsh/robs/shelld/scripts/*")

def run_scripts(pids, scripts)
  pids.each do |pid|
    scripts.each do |script|
      #cwd_file = "#{ENV['HOME']}/.shelld/#{pid}/cwd"
      output = `#{script} #{pid}`
      next if output.empty?
      puts output
    end
  end
end

remove_old_dirs(old_pids)
create_new_dirs(new_pids)
update_pid_dirs(pids)
run_scripts(pids, scripts)
