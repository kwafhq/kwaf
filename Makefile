# -------------------------------
# Reusable Makefile (Git namespace)
# -------------------------------
# Usage examples:
#   make git-start ISSUE=12                     # create & link a branch from an issue
#   make git-start ISSUE=12 NAME=feature/login  # custom branch name
#   make git-commit ISSUE=12 MSG="fix login bug"
#   make git-push
#   make git-pr ISSUE=12                        # open PR with "Closes #12"
#   make git-pr ISSUE=12 DRAFT=1                # open PR as Draft
#   make git-ready                              # mark PR "Ready for review"
#   make git-merge                              # squash-merge + delete branch (auto when checks pass)
#   make git-assign ISSUE=12                    # assign issue to yourself
#   make git-label ISSUE=12 LABEL=in-progress   # add label to issue
#   make git-status                             # show PR status for current branch
#
# Notes:
# - Requires GitHub CLI: https://cli.github.com/  (run `gh auth login` once)
# - `gh issue develop <num>` automatically links the branch to the issue (Development section)

SHELL := bash

# ----- Configurable defaults -----
BASE ?= main        # base branch for PRs
DRAFT ?= 0          # 1 = create PR as draft
LABEL ?= in-progress
# ---------------------------------

# Build a slug from issue title if NAME is not provided
define BRANCH_FROM_ISSUE
gh issue view $(ISSUE) --json title,number \
  --jq '(.title | ascii_downcase | gsub("[^a-z0-9]+"; "-") | gsub("(^-|-$)"; "")) + "-" + (.number|tostring)'
endef

ifeq ($(strip $(NAME)),)
BRANCH_CMD := $(BRANCH_FROM_ISSUE)
else
BRANCH_CMD := echo $(NAME)
endif

# ----- Internal guards -----
.PHONY: _git_check_tools _git_check_repo _need_issue _need_msg
_git_check_tools:
	@command -v gh >/dev/null || { echo "❌ gh CLI not found. Install: https://cli.github.com/"; exit 1; }
	@command -v git >/dev/null || { echo "❌ git not found."; exit 1; }

_git_check_repo:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "❌ Not a git repository."; exit 1; }

_need_issue:
	@test -n "$(ISSUE)" || { echo "❌ ISSUE is required. e.g., ISSUE=12"; exit 1; }

_need_msg:
	@test -n "$(MSG)" || { echo "❌ MSG is required. e.g., MSG=\"fix login bug\""; exit 1; }

# =============================
# Git / GitHub namespace targets
# =============================

.PHONY: git-start git-commit git-push git-pr git-ready git-merge git-assign git-label git-status

git-start: _git_check_tools _git_check_repo _need_issue
	@git fetch -q
	@git checkout $(BASE)
	@git pull --ff-only
	@BRANCH="$$( $(BRANCH_CMD) )"; \
	  echo "⏳ Creating branch from issue #$(ISSUE): $$BRANCH"; \
	  gh issue develop $(ISSUE) --name $$BRANCH; \
	  git push -u origin $$BRANCH; \
	  echo "✅ Linked & pushed: $$BRANCH"

git-commit: _git_check_tools _git_check_repo _need_issue _need_msg
	@git add -A
	@git commit -m "$(MSG) (#$(ISSUE))"
	@echo "✅ Commit created with Issue reference: #$(ISSUE)"

git-push: _git_check_tools _git_check_repo
	@git push
	@echo "✅ Pushed"

git-pr: _git_check_tools _git_check_repo _need_issue
	@CUR_BRANCH="$$(git rev-parse --abbrev-ref HEAD)"; \
	  TITLE="[#$(ISSUE)] $$(gh issue view $(ISSUE) --json title --jq .title)"; \
	  BODY="Closes #$(ISSUE)"; \
	  EXTRA=""; \
	  if [ "$(DRAFT)" = "1" ]; then EXTRA="--draft"; fi; \
	  echo "⏳ Creating PR: $$CUR_BRANCH -> $(BASE)"; \
	  gh pr create --base $(BASE) --head $$CUR_BRANCH --title "$$TITLE" --body "$$BODY" $$EXTRA; \
	  echo "✅ PR created. $$BODY"

git-ready: _git_check_tools _git_check_repo
	@gh pr ready
	@echo "✅ PR marked Ready for review"

git-merge: _git_check_tools _git_check_repo
	@gh pr merge --squash --delete-branch --auto
	@echo "✅ PR set to auto-merge (squash) and branch will be deleted after checks"

git-assign: _git_check_tools _git_check_repo _need_issue
	@gh issue edit $(ISSUE) --add-assignee @me
	@echo "✅ Issue #$(ISSUE) assigned to you"

git-label: _git_check_tools _git_check_repo _need_issue
	@gh issue edit $(ISSUE) --add-label $(LABEL)
	@echo "✅ Label '$(LABEL)' added to Issue #$(ISSUE)"

git-status: _git_check_tools _git_check_repo
	@echo "🔎 Current branch:" $$(git rev-parse --abbrev-ref HEAD)
	-@gh pr view --web >/dev/null 2>&1 || true
	@gh pr status || true
