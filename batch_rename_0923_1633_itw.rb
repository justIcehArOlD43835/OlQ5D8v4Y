# 代码生成时间: 2025-09-23 16:33:37
# Batch Rename API
class RenameAPI < Grape::API
  # Define route for batch renaming
  params do
    requires :files, type: Array[Hash], desc: 'Array of file paths with new names'
  end
  post 'rename' do
    # Extract file paths and new names from parameters
    files_to_rename = params[:files]

    # Initialize result array to store the status of each file rename
    result = []
    files_to_rename.each do |file|
      original_path = file[:path]
      new_name = file[:new_name]

      # Check if the file exists
      unless File.exist?(original_path)
        result.push({ original: original_path, new: new_name, status: 'error', message: 'File does not exist' })
        next
      end

      # Attempt to rename the file
      begin
        new_path = File.join(File.dirname(original_path), new_name)
        FileUtils.mv(original_path, new_path)
        result.push({ original: original_path, new: new_path, status: 'success' })
      rescue => e
        # Handle any exceptions that occur during the move operation
        result.push({ original: original_path, new: new_name, status: 'error', message: e.message })
      end
    end

    # Return the result of the batch rename operation
    { renamed: result }
  end
end

# Usage Documentation
# POST /rename
# Required parameters:
#   files: Array of objects containing 'path' and 'new_name' for each file to rename
# Example request body:
#   {"files": [{"path": "/path/to/file1.txt", "new_name": "new_file1.txt"}, {"path": "/path/to/file2.txt", "new_name": "new_file2.txt"}]}
# Response will contain an array of renamed file statuses with original paths, new paths, status, and error messages when applicable.
