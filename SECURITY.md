# Security Audit Report

## Overview
This document contains the findings of a security audit conducted on this macOS dotfile repository to identify potential sensitive information exposure.

## Audit Date
January 28, 2026

## Findings Summary

### ✅ No Critical Vulnerabilities Found
- **No API keys or tokens detected** in any files
- **No hardcoded passwords** found in configuration files
- **No private keys** (.pem, .key, id_rsa files) committed to the repository
- **No sensitive credentials** in environment variables
- **No secret files** (.env, *secret*, *credential*) tracked in git

### ⚠️ Personal Information Exposure (FIXED)

The following personal information was previously present in the repository but has been **fixed** by replacing hardcoded usernames with environment variables:

#### Username "skylar" (RESOLVED ✅)
Previously appeared in configuration files with hardcoded paths. **All instances have been replaced with portable path variables.**

**Previously in `.zprofile` (now fixed with `$HOME`):**
- `/Users/skylar/Library/pnpm` → `$HOME/Library/pnpm`
- `/Users/skylar/Library/Python/3.13/bin` → `$HOME/Library/Python/3.13/bin`
- `/Users/skylar/Library/Python/3.9/bin` → `$HOME/Library/Python/3.9/bin`
- `/Users/skylar/go/bin` → `$HOME/go/bin`
- `/Users/skylar/.bun/_bun` → `$HOME/.bun/_bun`
- `/Users/skylar/Library/TinyTeX/bin/universal-darwin` → `$HOME/Library/TinyTeX/bin/universal-darwin`

**Previously in `Library/Application Support/Code/User/settings.json` (now fixed with `~`):**
- `/Users/skylar/go` → `~/go`
- `/Users/skylar/Library/TinyTeX/bin/universal-darwin/texcount` → `~/Library/TinyTeX/bin/universal-darwin/texcount`
- `/Users/skylar/.leetcode` → `~/.leetcode`
- `file:///Users/skylar/.vscode.css` → `file://~/.vscode.css`
- `file:///Users/skylar/.vscode/extensions/...` → `file://~/.vscode/extensions/...`

## Risk Assessment

### No Remaining Risks ✅
All hardcoded usernames have been replaced with portable path variables, making the dotfiles:
1. **More portable** - works for any user without modifications (shell configs use `$HOME`, VS Code uses `~`)
2. **More secure** - no personal information exposure
3. **Best practice compliant** - follows dotfile security guidelines and tool-specific path conventions

### Recommendations

While the current state is secure, here are best practices for maintaining dotfile security:

#### 1. Use Environment Variables for User-Specific Paths ✅ IMPLEMENTED
**This has been implemented!** All hardcoded usernames have been replaced with portable path variables:

```bash
# Shell scripts (.zprofile, .zshrc) - using $HOME:
export PATH="$HOME/Library/pnpm:$PATH"
```

```json
// VS Code settings.json - using tilde (~):
{
  "go.gopath": "~/go",
  "leetcode.workspaceFolder": "~/.leetcode"
}
```

Previous examples that were fixed:
```bash
# Before (hardcoded):
export PATH="/Users/skylar/Library/pnpm:$PATH"

# After (now using $HOME):
export PATH="$HOME/Library/pnpm:$PATH"
```

```json
// Before (hardcoded):
{ "go.gopath": "/Users/skylar/go" }

// After (now using tilde):
{ "go.gopath": "~/go" }
```

#### 2. Keep Secrets Out of Dotfiles
- Never commit API keys, tokens, or passwords
- Use environment variables or secret management tools for credentials
- Consider using `.env` files (and add them to `.gitignore`)

#### 3. Use .gitignore Properly
The repository already has a good `.gitignore` file that excludes:
- Most `.config` directory contents
- `.zplug` directory contents (except packages list)
- DS_Store files

#### 4. Review Before Committing
Always review changes before committing to ensure no sensitive data is included:
```bash
git diff
git status
```

#### 5. Scan for Secrets Regularly
Consider using tools like:
- `git-secrets` - Prevents committing secrets
- `gitleaks` - Scans for hardcoded secrets
- `truffleHog` - Searches for high entropy strings

## Files Reviewed

The following files were examined during this audit:
- `.zshrc`
- `.zprofile`
- `.gitignore`
- `.brew_dump.txt`
- `.config/fastfetch/config.jsonc`
- `.config/htop/htoprc`
- `.config/neofetch/config.conf`
- `Library/Application Support/Code/User/settings.json`
- `Library/Application Support/Mousecape/capes/ZUTOMAYO.cape`

## Conclusion

✅ **This repository is secure and follows best practices.** 

- No sensitive credentials, API keys, tokens, or private keys were found
- All hardcoded usernames have been replaced with portable path variables:
  - Shell scripts use `$HOME` environment variable
  - VS Code settings use tilde (`~`) expansion
- Configuration files are now portable and will work for any user
- The repository follows dotfile security best practices

The audit identified minor username exposure in configuration paths, which has been **completely resolved** by replacing all hardcoded paths with appropriate portable path variables for each configuration type. The dotfiles are now more secure, portable, and maintainable.

---

*For questions or concerns about this security audit, please open an issue in the repository.*
