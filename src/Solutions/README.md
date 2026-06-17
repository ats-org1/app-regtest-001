# src/Solutions/

このディレクトリは **空** で払い出されます。

## 仕組み

1. CoE が repo を払い出した直後、この場所には Solution は存在しません (`.gitkeep` だけ)。
2. 案件 Maker が Power Platform の DEV 環境で **任意の名前** で Unmanaged Solution を作成します
   (例: `ContosoSalesApp`, `EmployeeOnboarding` など、案件のドメインに合った名前)。
3. Maker が GitHub Actions の **「Maker - DEV から保存」** ボタンを押し、Solution の Unique Name
   を入力 (例: `ContosoSalesApp`) すると、その時点の DEV の中身が export → unpack され、
   `src/Solutions/ContosoSalesApp/` として `develop` branch に commit されます。

## なぜテンプレに Solution ひな型を含めないか

- 案件ごとの Solution 名と一致させるためにテンプレ側で名前を強制する必要がなくなる
- テンプレに固定の Solution が残り続ける気持ち悪さを排除
- 「テンプレは骨格、中身は案件が育てる」という責務分離が明確になる

## 注意

- Maker は **最初の「Maker - DEV から保存」 / 「Maker - STG へリリース」 実行時に Solution Unique Name を必ず入力**
  してください (workflow 入力欄のデフォルト値 `SampleSolution` をそのまま使うと失敗します)。
- 入力した名前は `src/Solutions/<その名前>/` として保存されます。
