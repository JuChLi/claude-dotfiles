---
name: save
description: 儲存當前專案的工作進度到 .claude/progress.md，並自動歸檔歷史紀錄。在結束工作或需要暫停時使用。
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash, Read, Write, Glob, Grep
---

# 儲存專案進度

## 當前專案狀態

- Git 狀態：!`git status --short 2>/dev/null || echo "（非 Git 專案）"`
- 最近 Commits：!`git log --oneline -5 2>/dev/null || echo "（無 commit 紀錄）"`
- 變更統計：!`git diff --stat 2>/dev/null`
- Staged 變更：!`git diff --cached --stat 2>/dev/null`

## 執行步驟

1. **確認專案根目錄**：根據上方的 Git 狀態確認目前所在的專案，如果不是 Git 專案也可以繼續。
2. **建立目錄**：確保專案根目錄下有 `.claude/` 資料夾，沒有就建立。
3. **設定 .gitignore**：如果專案是 Git repo，檢查 `.gitignore` 是否已包含進度檔案的排除規則。如果沒有，追加以下內容（不要覆蓋原有內容）：
   ```
   # Claude Code progress (personal working state)
   .claude/progress.md
   .claude/progress-history.md
   ```
4. **歸檔舊進度**：
   - 讀取 `.claude/progress.md`，如果存在，將其完整內容**插入**到 `.claude/progress-history.md` 的**最前面**。
   - 在歸檔的段落上方加上 `---` 分隔線（第一筆不需要）。
   - 歷史檔案中越上面的紀錄越新。
5. **寫入最新進度**：覆寫 `.claude/progress.md`，格式如下：

```markdown
# 專案進度

- **專案路徑**：{工作目錄的絕對路徑}
- **儲存時間**：{YYYY-MM-DD HH:mm}

## 最近 Commits

{最近 5 筆 commit，格式為 `hash message`}

## 未提交的變更

{列出 staged / unstaged / untracked 檔案，無則寫「無」}

## 工作摘要

{根據本次對話內容，用 2-5 句話描述做了什麼、進行到哪裡}

## 待辦事項

- [ ] {尚未完成或接下來需要做的事}

## 重要備註

{已知 bug、臨時 workaround、需要注意的事項，無則寫「無」}
```

6. **回報結果**：告知使用者進度已儲存，簡要顯示工作摘要與待辦事項數量。如果有歸檔舊進度，一併告知。

## 注意事項

- 所有內容使用**繁體中文**撰寫。
- 工作摘要應根據本次對話的實際操作來寫，不要只抄 git log。
- 待辦事項應具體、可執行，避免過於籠統。
