import os
import yaml

# Create a directory to store the YAML files
output_dir = "."
os.makedirs(output_dir, exist_ok=True)

# Generate 500 YAML files
for i in range(1, 501):
    workspace_name = f"dev{i}-scale3"  # Increment the workspace_name
    data = {
        "organization": "hashi-demos-apj",
        "workspace_name": workspace_name,
        "create_project": False,
        "project_name": "Simons Project",
        "create_repo": False,
        "create_variable_set": False,
    }

    # Create a YAML file with the data
    file_name = os.path.join(output_dir, f"dev{i}-scale3.yaml")
    with open(file_name, "w") as file:
        yaml.dump(data, file)

print("500 YAML files generated.")