import os

# Compile the calculator
os.system("make")

for file_name in sorted(os.listdir("tests")):
    if file_name.endswith(".in"):
        # Construct the paths for the input and expected output files
        input_path = os.path.join("tests", file_name)
        expected_path = os.path.join("tests", file_name[:-3] + ".expected")

        # Read the input and expected output
        with open(input_path, "r") as input_file:
            input_str = input_file.read().strip()
        with open(expected_path, "r") as expected_file:
            expected_str = expected_file.read().strip()

        # Run the test and capture the output and error
        cmd = f"./cnf < {input_path} 2>&1"
        result = os.popen(cmd).read().strip()

        # Compare the output to the expected output
        if "".join(result.split()) != "".join(expected_str.split()):
            print(f"Test {file_name[:-3]} failed 🇽:")
            print(f"Input:\n{input_str}")
            print("Character-by-character comparison:")
            print(f"Expected output:\n{expected_str}")
            print(f"Actual output:\n{result}")
            print()
        else:
            print(f"Test {file_name[:-3]} passed ☑️")

# Delete the generated files
os.system("make clean")
