import os

# Define the directory path
directory_path = "/projects/synergy_lab/garvit217/enhancement_data/train/HQ/"  # Replace with your actual directory path

# Check if the directory exists
if not os.path.exists(directory_path):
    print(f"The directory '{directory_path}' does not exist.")
    exit()

# Get a list of sorted files
files = sorted(os.listdir(directory_path))

# Print the sorted files
print("Sorted Files:")
for file in files:
    print(file)

# Get the item at index length of directory_path / 2
length = len(files)
if length > 0:
    middle_item = files[length // 2]
    print(f"\nThe item at index {length // 2} is: {middle_item}")
else:
    print("The directory is empty.")