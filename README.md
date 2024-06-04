# <p align="center">🔧 Git-Switch</p>

# 📝 About
## Git-Switch - 2 Github Accounts on the same linux user
# 📚 Index
- 🔖 [Git-Switch](#-git-switch)<br>
    - 🔖 [Switch Github Account](#-switch-github-account)<br>
    - 🔖 [Generate SSH Key](#-generate-ssh-key)<br>
    - 🔖 [Test Github SSH connection](#-test-github-ssh-connection)<br>
    - 🔖 [Set Github account](#-set-github-account)<br>
    - 🔖 [Fix file permissions](#-fix-file-permissions)<br>
- ### ❗REQUIREMENTS FOR EXISTING ACCOUNTS❗
- Generate SSH key for account 1
    - Rename SSH Key for account 1: 
    ```bash 
    mv ~/.ssh/id_ed25519.pub ~/.ssh/id_ed25519_account1.pub
    mv ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_account1
    ```
- Generate SSH key for account 2
    - Rename SSH Key for account 2: 
    ```bash 
    mv ~/.ssh/id_ed25519.pub ~/.ssh/id_ed25519_account2.pub
    mv ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_account2
    ```
   
---
# 🔧 Git-Switch
# For Linux 🐧
```
wget hhttps://raw.githubusercontent.com/PhilipMello/git-switch/main/gswitch && chmod +x gswitch
```
RUN:
```
./gswitch
```

Manual:
```
./gswitch -h
```

To run in Pipeline:
```
./gswitch --account1 OR ./giswitch --account2
```
---
# For Windows 🪟
```
wget https://github.com/PhilipMello/scripts/blob/main/gswitch.ps1
```
RUN:
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser && ./git-switch.ps1
```

## 🔧 Switch Github Account
![](assets/img/github-account-switch.gif)

---
## 🔧 Generate SSH Key
![]()

---
## 🔧 Test Github SSH connection
![](assets/img/github-test-connection_account1.gif)

---
## 🔧 Set Github account
![]()

---
## 🔧 Fix file permissions
![](assets/img/github-fix-file-permission.gif)