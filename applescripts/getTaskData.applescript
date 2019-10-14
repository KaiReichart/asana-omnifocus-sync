use application "OmniFocus"
use O : script "omnifocus"
use json : script "json"

on run argv
	set taskId to (item 1 of argv)
	
	tell O
		set theTask to first flattened task of default document where its id is taskId
		set json_dict to json's createDictWith({{"id", (id of theTask)}, {"name", (name of theTask)}, {"completed", (completed of theTask)}, {"due_on", (due date of theTask as string)}, {"notes", (note of theTask)}, {"created", (creation date of theTask as string)}, {"modified", (modification date of theTask as string)}})
		return json's encode(json_dict)
	end tell
end run