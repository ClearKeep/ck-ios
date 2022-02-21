# Danger swiftlint
swiftlint.lint_files inline_mode: true

warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"
warn("Big PR") if git.lines_of_code > 500

if github.pr_body.length < 5
    fail "Please provide a summary in the Pull Request description"
end

files_to_check = (git.modified_files + git.added_files).uniq
(files_to_check - %w(Dangerfile)).each do |file|
	next unless File.file?(file)
	next unless File.extname(file).include?(".swift")

	foundMark = false 
	hasLocalizedKeys = []
	disabled_rules = []

	filelines = File.readlines(file)
	filelines.each_with_index do |line, index|
        if line.include?("unowned self")
            warn("It's safer to use weak instead of unowned", file: file, line: index+1) 
        end

        if line.include?("override") and line.include?("func") and filelines[index+1].include?("super") and filelines[index+2].include?("}")
            warn("Override methods which only call super can be removed", file: file, line: index+3) 
        end

        if line.include?("MARK:") and line.include?("//")
            foundMark = true
        end
	end

	addedLines = git.diff_for_file(file).patch.lines
	addedLines.each_with_index do |line, index|
		if line.include?(".localized") and (line.start_with?("+") or line.start_with?("d"))
			key = line[/\"(.*)\".localized/, 1]
			unless key.nil? || key.empty?
				hasLocalizedKeys.append key
			end
		end
	end

	## Check wether our file is larger than 200 lines and doesn't include any Marks
	if filelines.count > 200 and foundMark == false 
		warn("Consider to place some `MARK:` lines for files over 200 lines big.")
	end

	## Self-review Localized
	hasLocalizedKeys.sort.uniq.each do |key|
		markdown('- [ ] I understand that "' + key + '" is now existed in Localized service')
	end
end