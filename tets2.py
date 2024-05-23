import json

data = {
    "steps": [
        {
            "command": "python3 test_script.py --experiment"
        }
    ]
}


json_string = json.dumps(data)
print(json_string)
print(data)