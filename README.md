# Power Platform 案件 repo

このリポジトリは CoE が運用する Power Platform 案件 1 件分のリポジトリです。Maker は Power Platform 側 (Make.powerautomate.com) で開発し、本リポジトリは **環境オーナー** が STG / PRD へのリリース操作を行うため、**IT DRI (デプロイ承認者)** が承認判断を行うために使います。

> 設計・実装の詳細管理は CoE 側で行います。本リポジトリは「決まった操作ボタンを押す場所」「承認画面」として使ってください。

---

## 環境オーナー向け: 操作ボタン

`Actions` タブから以下の workflow を `Run workflow` で起動します。各 workflow に `solution_name` と `reason` などの入力欄が出るので、対象の Solution 名と実行理由を埋めて Run してください。

| やりたいこと | Workflow 名 | 起動先のブランチ |
| --- | --- | --- |
| DEV の現状を保存 (Solution export + Version bump + settings 雛型生成) | `Maker - DEV から保存` (maker-00) | `main` でも `develop` でも可 (内部で develop に commit される) |
| STG にリリース (develop → main の release PR + auto-merge → STG deploy) | `Maker - STG へリリース` (maker-01) | `main` |
| PRD にリリース (verified tag を検証 → PRD deploy) | `Maker - PRD へリリース` (maker-02) | `main` |
| STG の接続情報・環境変数を更新 | `Maker - STG 接続情報・環境変数 登録/更新` (maker-03) | `main` |
| PRD の接続情報・環境変数を更新 | `Maker - PRD 接続情報・環境変数 登録/更新` (maker-04) | `main` |

実行結果のログは Actions タブの run 画面で確認できます。失敗時は log 末尾に Step Summary が出ます。

---

## IT DRI (デプロイ承認者) 向け: 承認判断

GitHub Environments の承認待ち通知 (メール / Web 画面) が届いたら、`Settings → Environments` ではなく、**Actions の対象 run** を開いて Review pending deployments から承認/却下します。

承認画面右側の **「View environment」リンク** から、その回のリリース内容 (release PR / Release notes) に 1 クリックで飛べるようにしてあります。これを開いて「何が入っているか」を確認してから判断してください。

| Environment | 何の承認か | 承認前に確認 (View environment リンク先) | 却下するケース |
| --- | --- | --- | --- |
| `stg` | STG への deploy 実行 | release PR (develop→main) を開き、PR description (環境オーナーが書いた変更概要) / Commits / Files changed を確認 | 変更概要が空 / リリース計画外 |
| `stg-verified` | STG 動作確認完了 → `v<x.y.z>-stg-verified` tag + Release 自動生成 | 同じ release PR (= 直前に STG にデプロイした内容)。環境オーナー / Maker から STG 動作確認 OK の報告を受領済か | 動作 NG / 確認未完 / 報告未受領 |
| `prd` | PRD への deploy 実行 | `v<x.y.z>-stg-verified` の Release ページ。Release notes と attach 済 managed zip がそのまま PRD に流れる | リリース計画外 / Release notes と変更概要が一致しない |
| `prd-verified` | PRD 動作確認完了 → `v<x.y.z>-prd-verified` tag + Release 自動生成 | 同じ `-stg-verified` Release (= PRD に実際 import した zip)。環境オーナー / Maker から PRD 動作確認 OK の報告を受領済か | 動作 NG / Rollback 要 / 報告未受領 |

却下した場合、Maker / 環境オーナー側で修正 → 再度 maker-01 / maker-02 から流し直す動線になります。

---

## このリポジトリの中身 (参考)

環境オーナー / IT DRI が日常で触る必要はありません。

```
.github/workflows/   操作ボタン (maker-XX) と CI/CD 中継 workflow
src/Solutions/       Solution のソース (maker-00 が unpack/保存)
scripts/             ローカル検証用補助スクリプト (CI からは未使用)
```

リリース動線・workflow 詳細・設計図はすべて CoE 側で管理しています。
