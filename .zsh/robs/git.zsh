# check for changes in any git repositories in the current directory
function gc {
  for f in *; do
    (
      cd $f
      test -d .git && \
        (
          echo "## repository: $f"
          git status
          echo
        )
    )
  done
}
