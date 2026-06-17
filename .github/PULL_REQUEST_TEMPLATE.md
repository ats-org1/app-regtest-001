# 手動 PR 起票 (例外運用)

> **通常運用ではこのテンプレは出ません**。
> 通常の PR は `maker-01-deploy-to-stg` (release PR) と `maker-04-update-prd-settings` (PRD settings PR) が**自動起票**します。
> WF が起票する PR は `gh pr create --body` で description を埋めるため、本テンプレ MD は使われません。
> このテンプレが見えているということは、**Web UI または `gh pr create` で手動 PR を起こそうとしている**状態です。

## まずは確認

- [ ] `maker-01-deploy-to-stg` で代替できない (例: develop に出ていない hotfix を main に直接当てたい)
- [ ] `maker-04-update-prd-settings` で代替できない (例: PRD settings 以外のファイルを PRD 経路で変更したい)
- [ ] 上記いずれも該当しない → CoE リードに相談してから起票

## 起票理由
<!-- なぜ自動 PR でなく手動 PR が必要か (例: 緊急 hotfix / 設計外の差分修正) -->

## 影響範囲
- [ ] STG のみ
- [ ] PRD まで波及
- [ ] 設計書 / Workflow 定義の変更 (本テンプレは案件 repo 用、coe-central-repo 側の変更ならそちらで PR を起こすこと)

## 承認の前提
<!-- 通常運用外なので、CoE リードと環境オーナーの合意取得状況を記載 -->

## 関連ドキュメント

- リリース動線全体: [07-workflow-spec.md](https://github.com/ats-org1/coe-central-repo/blob/main/docs/design/07-workflow-spec.md)
- ブランチ運用: [05-branching-source-control.md](https://github.com/ats-org1/coe-central-repo/blob/main/docs/design/05-branching-source-control.md)
