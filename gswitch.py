import os
import subprocess
import re
import sys
from datetime import datetime
from getpass import getpass

# Metadata
author = "Philip Mello <@Microsoft>"
version = "1.2"
license = "MIT"
current_date = datetime.now().strftime('%b %d, %Y')
github_url = 'https://github.com/PhilipMello/git-switch'
script = "GitHub Account Switch"
description = "Multiple Github Accounts into one CLI"

print(f"""
        _____         _ _       _     
       / ____|       (_) |     | |      {version}
  __ _| (_____      ___| |_ ___| |__    {current_date}
 / _. |\___ \ \ /\ / / | __/ __| |_ \   {author}
| (_| |____) \ V  V /| | || (__| | | |  {license}
 \___ |_____/ \_/\_/ |_|\__\___|_| |_|
  __/ |                               
 |___/  {github_url}                              

# --------------------------------------------------------------
# Script     : {script}
# Description: {description}
# --------------------------------------------------------------
# How to use: Execute gswitch
# Examples:
# Manual: gswitch -h OR gswitch --h OR gswitch --help
# Switch account using parameter: gswitch --account1
# --------------------------------------------------------------
""")

def generate_ssh_key():
    print("Go to your GitHub Portal and add your SSH Key: https://github.com/settings/ssh/new")

    try:
        num_accounts = int(input("How many GitHub accounts do you want to create (0-9)? "))
    except ValueError:
        print("Invalid number. Please enter a number between 0 and 9.")
        sys.exit(1)
    
    if not (0 <= num_accounts <= 9):
        print("Invalid number. Please enter a number between 0 and 9.")
        sys.exit(1)
    
    for i in range(num_accounts):
        github_email_account = input(f"Type your GitHub email account for account #{i}: ")
        if not re.match(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$', github_email_account):
            print("Invalid email format. Please try again.")
            continue

        key_path = os.path.expanduser(f"~/.ssh/id_ed25519_account_{i}")
        subprocess.run(["ssh-keygen", "-t", "ed25519", "-C", github_email_account, "-f", key_path])

        print(f"""
        +-----------------------------------------------------------+
        | SSH key generated for: {github_email_account}
        | Key saved as: {key_path}
        +-----------------------------------------------------------+
        """)

def test_github_connection():
    print("Github connection testing...")
    subprocess.run(["ssh", "-T", "git@github.com"])

def set_github_account():
    github_set_account_name = input("Enter your GitHub Account Name: ")
    github_set_account_email = input("Enter your GitHub Account Email: ")
    subprocess.run(["git", "config", "user.name", github_set_account_name])
    subprocess.run(["git", "config", "user.email", github_set_account_email])

def switch_github_account():
    print("You're logged in as:")
    subprocess.run(["ssh", "-T", "git@github.com"])

    emails, files = [], []

    ssh_dir = os.path.expanduser("~/.ssh")
    for file in os.listdir(ssh_dir):
        if file.startswith("id_"):
            file_path = os.path.join(ssh_dir, file)
            with open(file_path, 'r') as f:
                content = f.read()
                match = re.search(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+', content)
                if match:
                    emails.append(match.group(0))
                    files.append(file)

    if not emails:
        print("No accounts found.")
        sys.exit(1)

    print("Select an email:")
    for idx, email in enumerate(emails, start=1):
        print(f"{idx}. {email}")

    try:
        choice = int(input("Enter the number of your account: ")) - 1
        if not (0 <= choice < len(emails)):
            raise ValueError
    except ValueError:
        print("Invalid choice. Exiting.")
        sys.exit(1)

    selected_email = emails[choice]
    selected_file = files[choice]

    print(f"Github Account {selected_email} Selected!")
    subprocess.run(["cp", os.path.join(ssh_dir, selected_file), os.path.join(ssh_dir, "id_ed25519")])
    subprocess.run(["ssh", "-T", "git@github.com"])

def fix_permissions():
    print("Fixing SSH file permissions...")
    ssh_dir = os.path.expanduser("~/.ssh")
    subprocess.run(["chmod", "700", ssh_dir])
    for file in os.listdir(ssh_dir):
        if file.startswith("id_"):
            subprocess.run(["chmod", "600", os.path.join(ssh_dir, file)])
    print("""
    +-----------------------------------------------------------+
    | Files permissions have been fixed
    +-----------------------------------------------------------+
    """)

def show_github_config():
    print("Run gSwitch in git directory level")
    subprocess.run(["git", "config", "--list", "--show-origin"])

def show_accounts():
    ssh_dir = os.path.expanduser("~/.ssh")
    for file in os.listdir(ssh_dir):
        if file.startswith("id_"):
            with open(os.path.join(ssh_dir, file), 'r') as f:
                content = f.read()
                matches = re.findall(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+', content)
                for email in matches:
                    print("-----------------------------------------")
                    print(f"| Email: {email} |")
                    print("-----------------------------------------")

def manual():
    print("""
    Generate 2 SSH Keys and rename GitHub account to
    id_ed25519_account1 and GitHub account 2 to id_ed25519_account2 in ~/.ssh
    
    Parameters:
    --account1          Switch to GitHub Account 1
    --account2          Switch to GitHub Account 2
    """)
    sys.exit(0)

if len(sys.argv) > 1:
    arg = sys.argv[1]
    ssh_dir = os.path.expanduser("~/.ssh")
    if arg in ["-h", "--help", "--h"]:
        manual()
    elif arg == "--account1":
        subprocess.run(["cp", os.path.join(ssh_dir, "id_ed25519_account1"), os.path.join(ssh_dir, "id_ed25519")])
        print("Github Account #1 has been selected!")
        test_github_connection()
        sys.exit(0)
    elif arg == "--account2":
        subprocess.run(["cp", os.path.join(ssh_dir, "id_ed25519_account2"), os.path.join(ssh_dir, "id_ed25519")])
        print("Github Account #2 has been selected!")
        test_github_connection()
        sys.exit(0)

print("""
Choose an option:
1. Switch GitHub Account
2. Generate SSH Key
3. Test GitHub SSH connection
4. Set GitHub account
5. Fix SSH file permissions
6. Show current GitHub config
7. Show Accounts in ~/.ssh
""")

option = input("Enter your choice: ")

if option == "1":
    switch_github_account()
elif option == "2":
    generate_ssh_key()
elif option == "3":
    test_github_connection()
elif option == "4":
    set_github_account()
elif option == "5":
    fix_permissions()
elif option == "6":
    show_github_config()
elif option == "7":
    show_accounts()
else:
    print("Invalid option")
