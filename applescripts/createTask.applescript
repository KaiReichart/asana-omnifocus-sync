-- Convert date function. Call with string in YYYY-MM-DD HH:MM:SS format (time part optional)
on convertDate(textDate)
	set resultDate to the current date
	
	set the year of resultDate to (text 1 thru 4 of textDate)
	set the month of resultDate to (text 6 thru 7 of textDate)
	set the day of resultDate to (text 9 thru 10 of textDate)
	set the time of resultDate to 0
	
	if (length of textDate) > 10 then
		set the hours of resultDate to (text 12 thru 13 of textDate)
		set the minutes of resultDate to (text 15 thru 16 of textDate)
		
		if (length of textDate) > 16 then
			set the seconds of resultDate to (text 18 thru 19 of textDate)
		end if
	end if
	
	return resultDate
end convertDate

use application "OmniFocus"
use O : script "omnifocus"

on run argv
	set taskName to (item 1 of argv)
	set projectName to (item 2 of argv)
	set sectionName to (item 3 of argv)
	set dueDate to (item 4 of argv)
	set notes to (item 5 of argv)
	
	if (dueDate is not "-") then
		set convertedDueDate to convertDate(dueDate)
	end if
	
	tell O

	-- CREATE ASANA TAG IF NOT EXISTS
		set foundTag to 0
		try
			tell default document
				set theTag to the first flattened tag where its name = "Asana"
				set foundTag to 1
			end tell
		end try
		if (foundTag is 0) then
			tell default document
				set theTag to make new tag with properties {name:"Asana"}
				set foundTag to 1
			end tell
		end if

	-- CREATE PROJECT IF NOT EXISTS
		set foundProject to 0
		if (projectName is not "-") then
			try
				tell default document
					set theProject to the first flattened project where its name = projectName
					set foundProject to 1
				end tell
			end try
			if (foundProject is 0) then
				tell default document
					set theProject to make new project with properties {name:projectName}
					set foundProject to 1
				end tell
			end if
			
		end if


		tell default document
			set theTask to make new inbox task with properties {name:taskName, primary tag: theTag}
			if (foundProject is 1) then
				move theTask to end of tasks of theProject
			end if
		end tell

		
		if (dueDate is not "-") then
			set due date of theTask to convertedDueDate
		end if
		
		if (notes is not "-") then
			set note of theTask to notes
		end if
		
		return id of theTask
	end tell
	
	--set transportText to (item 1 of argv)
	
	--tell O
	--	set parseResponse to parse(transportText)
	--	set newTask to first item of parseResponse
	--	return id of newTask
	--end tell
end run