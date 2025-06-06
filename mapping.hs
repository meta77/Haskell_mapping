import Data.List (nub, sort)

-- 写像のデータ型
data Mapping a b = Mapping {
  apply :: a -> b,    -- 写像の本体 (関数)
  domain :: [a],      -- 定義域 (A)
  codomain :: [b]     -- 値域 (B)
}

{-
「コンストラクタ」の基礎を確認

データ型から、実際の「値」を作るときに使う特別な関数。
・「型」だけ ⇒ 設計図だけ
・「コンストラクタ」⇒ 実際に中身を作る道具

-}


-- 単射判定
isInjective :: (Eq b) => Mapping a b -> Bool -- 入力は「写像」型。出力は Bool型。
isInjective (Mapping f dom _) =
  let images = map f dom
  in length (nub images) == length images -- nub リストの重複を取り除きます。標準ライブラリの関数です（Data.Listにあります）。
{-
単射判定のロジック

「重複を除いた長さ」と「元の長さ」が等しいか？　
→重複がなければ、つまり「全て異なっていれば、単射。True。

-}

{-
let in構文の再確認

    let で定義した値を使って、
    in で本体の式を評価する
-}


-- 全射判定
isSurjective :: (Eq b) => Mapping a b -> Bool
isSurjective (Mapping f dom codom) =
  let images = map f dom
  in all (`elem` images) codom
{-
全射判定のロジック

値域 codom のすべての要素が、images に含まれているか？

-}

{-
all

型: all :: (a -> Bool) -> [a] -> Bool
意味: 「リストのすべての要素が、条件を満たすか？」
-}

{-
(`elem` images)

セクション記法で、無名関数です。
\x -> x `elem` images と同じ。
-}


-- 全単射判定
isBijective :: (Eq b) => Mapping a b -> Bool
isBijective m = isInjective m && isSurjective m





-- 写像の例

-- 写像例1: 自然数 1,2,3 -> 自然数 2,4,6 (倍)
doubleMap :: Mapping Int Int
doubleMap = Mapping {
  apply = (*2),
  domain = [1,2,3],
  codomain = [2,4,6]
}

-- 写像例2: 自然数 1,2,3 -> 自然数 1,2,2 (ダブりあり)
dupMap :: Mapping Int Int
dupMap = Mapping {
  apply = \x -> if x == 1 then 1 else 2,
  domain = [1,2,3],
  codomain = [1,2]
}

-- 写像例3
zeroMap :: Mapping Int Int
zeroMap = Mapping {
    apply = \x -> x * 0,
    domain = [1,2,3],
    codomain = [0]
}

-- 写像例４
-- 平方剰余写像 f(x) = x^2 mod 7, x ∈ {0..6}
quadraticMod7 :: Mapping Int Int
quadraticMod7 = Mapping {
  apply = \x -> (x * x) `mod` 7,
  domain = [0..6],
  codomain = [0..6]  -- ℤ/7ℤ の元
}

-- 写像例5
-- 恒等写像 on [1..5]
identityMapping :: Mapping Int Int
identityMapping = Mapping {
  apply = \x -> x,         -- 恒等関数
  domain = [1..5],
  codomain = [1..5]
}

-- 実行例
main :: IO ()
main = do
  putStrLn $ "doubleMapは単射か？ " ++ show (isInjective doubleMap) -- True
  putStrLn $ "doubleMapは全射か？ " ++ show (isSurjective doubleMap) -- True
  putStrLn $ "doubleMapは全単射か？ " ++ show (isBijective doubleMap) -- True

  putStrLn $ "dupMapは単射か？ " ++ show (isInjective dupMap) -- False
  putStrLn $ "dupMapは全射か？ " ++ show (isSurjective dupMap) -- True
  putStrLn $ "dupMapは全単射か？ " ++ show (isBijective dupMap) -- False

  putStrLn $ "zeroMapは単射か？ " ++ show (isInjective zeroMap) -- False
  putStrLn $ "zeroMapは全射か？ " ++ show (isSurjective zeroMap) -- True
  putStrLn $ "zeroMapは全単射か？ " ++ show (isBijective zeroMap) -- False

  putStrLn $ "quadraticMod7は単射か？ " ++ show (isInjective quadraticMod7) -- False
  putStrLn $ "quadraticMod7は全射か？ " ++ show (isSurjective quadraticMod7) -- True
  putStrLn $ "quadraticMod7は全単射か？ " ++ show (isBijective quadraticMod7) -- False

  putStrLn $ "identityMappingは単射か？ " ++ show (isInjective identityMapping) -- False
  putStrLn $ "identityMappingは全射か？ " ++ show (isSurjective identityMapping) -- True
  putStrLn $ "identityMappingは全単射か？ " ++ show (isBijective identityMapping) -- False