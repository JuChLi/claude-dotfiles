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

每個步驟完成後，輸出一行包含 ✅ 的結果摘要，格式為：
`✅ [N/9] 步驟名稱 — 結果說明`
如果該步驟被跳過，使用 ⏭️ 代替 ✅。

1. **確認專案根目錄**：根據上方的 Git 狀態確認目前所在的專案，如果不是 Git 專案也可以繼續。
   - 完成後輸出：`✅ [1/9] 確認專案根目錄 — {專案路徑}（Git 專案 / 非 Git 專案）`

2. **建立 .claude/ 資料夾**：確保專案根目錄下有 `.claude/` 資料夾，沒有就建立。
   - 完成後輸出：`✅ [2/9] 建立 .claude/ 資料夾 — 已建立` 或 `✅ [2/9] 建立 .claude/ 資料夾 — 已存在`

3. **檢查 .gitignore 設定**：如果專案是 Git repo，檢查 `.gitignore` 是否已包含進度檔案的排除規則。如果沒有，追加以下內容（不要覆蓋原有內容）：
   ```
   # Claude Code progress (personal working state)
   .claude/progress.md
   .claude/progress-history.md
   ```
   - 完成後輸出：`✅ [3/9] 檢查 .gitignore 設定 — 已追加規則` 或 `✅ [3/9] 檢查 .gitignore 設定 — 已包含`

4. **歸檔舊進度**：
   - 讀取 `.claude/progress.md`，如果存在，將其完整內容**插入**到 `.claude/progress-history.md` 的**最前面**。
   - 在歸檔的段落上方加上 `---` 分隔線（第一筆不需要）。
   - 歷史檔案中越上面的紀錄越新。
   - 完成後輸出：`✅ [4/9] 歸檔舊進度 — 已歸檔至 progress-history.md` 或 `⏭️ [4/9] 歸檔舊進度 — 無舊進度`

5. **提交變更到 Git**（僅限 Git 專案，且有待提交的變更時）：
   - 執行 `git add -A` 將所有變更加入 staging。
   - 用簡潔的 commit message 執行 `git commit`，格式：`chore: save progress — {一句話摘要}`。
   - 完成後輸出：`✅ [5/9] 提交變更到 Git — {commit hash}` 或 `⏭️ [5/9] 提交變更到 Git — 無變更`

6. **推送到遠端**（僅限 Git 專案，且有設定遠端 remote 時）：
   - 執行 `git push`。
   - 如果 push 失敗（例如沒有設定 upstream），告知使用者但不中斷流程。
   - 完成後輸出：`✅ [6/9] 推送到遠端 — 已推送至 origin/main` 或 `⏭️ [6/9] 推送到遠端 — 跳過（無遠端）`

7. **寫入最新進度**：覆寫 `.claude/progress.md`，格式如下：

```markdown
# 專案進度

- **專案路徑**：{工作目錄的絕對路徑}
- **儲存時間**：{YYYY-MM-DD HH:mm}

## 目標

{這次工作要達成什麼，用一句話描述北極星目標}

## 進度狀態

<!-- 狀態：pending / in_progress / complete -->
| 階段 | 狀態 |
|------|------|
| {階段 1 描述} | {狀態} |
| {階段 2 描述} | {狀態} |
| ... | ... |

## 工作摘要

{根據本次對話內容，用 2-5 句話描述做了什麼、進行到哪裡}

## 修改的檔案

<!-- load 時快速定位相關檔案 -->
- `{檔案路徑}` — {簡述修改內容}
- ...

## 決策紀錄

<!-- 記住為什麼這樣做，無則寫「無」 -->
| 決策 | 理由 |
|------|------|
| {決策內容} | {理由} |

## 錯誤追蹤

<!-- 避免重複犯錯，無則寫「無」 -->
| 錯誤 | 嘗試 | 解決方式 |
|------|------|----------|
| {錯誤描述} | {第幾次} | {如何解決} |

## 待辦事項

- [ ] {尚未完成或接下來需要做的事}

## Git 狀態

### 最近 Commits

{最近 5 筆 commit，格式為 `hash message`}

### 未提交的變更

{列出 staged / unstaged / untracked 檔案，無則寫「無」}

## 5-Question Check

<!-- load 時快速驗證 context 完整性 -->
| 問題 | 答案 |
|------|------|
| 我在哪？ | {目前進行到哪個階段} |
| 要去哪？ | {剩餘的階段} |
| 目標是什麼？ | {重述目標} |
| 學到什麼？ | {關鍵發現或決策} |
| 做了什麼？ | {簡述已完成的工作} |

## 重要備註

{已知 bug、臨時 workaround、需要注意的事項，無則寫「無」}
```

   - 完成後輸出：`✅ [7/9] 寫入最新進度 — 已覆寫 progress.md`

8. **確認 repo 狀態**（僅限 Git 專案）：
   - 執行 `git status` 確認工作區是否乾淨。
   - 執行 `git log --oneline -3` 確認最新 commit。
   - 將結果納入回報。
   - 完成後輸出：`✅ [8/9] 確認 repo 狀態 — 工作區乾淨` 或 `✅ [8/9] 確認 repo 狀態 — 仍有未提交變更`

9. **回報結果**：在所有 ✅ 清單之後，輸出一段結果摘要，包含：
   - 工作摘要與待辦事項數量
   - 如果有歸檔舊進度，一併告知
   - Commit hash 與 push 結果
   - Repo 最終狀態（乾淨 / 仍有未追蹤檔案）
   - 最後輸出：`✅ [9/9] 儲存完成！`

## 注意事項

- 所有內容使用**繁體中文**撰寫。
- 工作摘要應根據本次對話的實際操作來寫，不要只抄 git log。
- 待辦事項應具體、可執行，避免過於籠統。
