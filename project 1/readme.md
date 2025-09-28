# 🐧 User Creation Script

## 📌 Overview
This script automates the process of creating Linux users from a **CSV file**.

- Reads usernames from a CSV file.  
- Checks if each user already exists.  
- Creates the user if they don’t exist.  
- Assigns a random password generated with `openssl`.  
- Saves the created usernames and passwords into a file for reference.

This helps streamline onboarding and prevents duplicate user creation.

---

## ⚙️ Workflow

1. **Input file (`random_names.csv`)**  
   - Contains raw names (e.g., `John Smith`, `Sophia Miller`).  
   - Script preprocesses names into valid Linux usernames:  
     - Converts to lowercase  
     - Replaces spaces with underscores  
     - Removes duplicates  

2. **User check & creation**  
   - Uses `id username` to check if the user exists.  
   - If exists → skip.  
   - If not → create with `adduser`.  

3. **Password assignment**  
   - Generates a random password with:  
     ```bash
     openssl rand -hex 8
     ```

4. **Credential storage**  
   - Saves new `username:password` pairs into an output file.

---

## 🚀 Usage

### Step 1 — Download CSV from GitHub
If your CSV file is stored in a **public GitHub repository**:

1. Open the file in GitHub.  
2. Click **Raw** (top-right).  
3. Copy the URL (it will look like):  

```sh
https://raw.githubusercontent.com/username/repo-name/main/path/to/file.csv
```

4. Download it with `wget`:  
```bash
wget https://raw.githubusercontent.com/username/repo-name/main/path/to/file.csv -O random_names.csv
```

5. Make the script executable and run the script:
```sh
chmod +X create-user.sh
./script.sh
```

6. Confirm  user creation:
```sh
cat /etc/passwd
```
