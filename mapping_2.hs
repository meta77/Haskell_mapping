{-# LANGUAGE TypeFamilies #-} -- 「関連型（associated type）」を定義するため。


-- Mapping を型クラスで抽象化
class Mapping f where
  type Domain f
  type Codomain f
  apply :: f -> Domain f -> Codomain f

{-
型クラスの中での「type」の意味

「関連型（associated type）」を定義するため。

「型 f（例えば関数やデータ構造など）に、それぞれ異なる**定義域（Domain）と値域（Codomain）**の型がある」
→ それを明示的に型として指定したい！

型クラスの中で type Something f のように書くと、
それは 「型引数 f に関連付けられた別の型」 を定義する、という意味になります。
これは普通の型パラメータではなく、型ファミリー（type family） という仕組みで実現されます。

より自然に「型に対してその性質・構造を与える」ため

この機能を使うには GHC 拡張：
{-# LANGUAGE TypeFamilies #-}
をソースコードの先頭に書く必要があります。

・インスタンスの作り方
「インスタンスを定義するとき、f が持つ型情報を使って、type Domain f と type Codomain f を定義する」
instance Mapping (a -> b) where
  type Domain (a -> b) = a
  type Codomain (a -> b) = b
  apply f x = f x
-}





-- 拡張された構造付き写像
data Mapping a b = Mapping {
  apply     :: a -> b,
  domainSet :: a -> Bool,    -- 属するかどうか（∞集合でもOK）
  codomainSet :: b -> Bool   -- 値域として含まれるか
}

{-
なぜ拡張版？

data Mapping a b = Mapping {
  apply   :: a -> b,
  domain  :: [a],
  codomain :: [b]
}

の場合、
・domain や codomain が列挙可能な有限集合に限定される
・無限集合（例えば自然数全体や実数区間）をうまく扱えない

拡張版では、
・無限集合も扱える（例：domainSet x = x >= 0）
・集合を「列挙」ではなく「条件」で定義できる
・より数学的に厳密なモデリングが可能
・「属する／属さない」の情報を明示的に持つことで、写像の安全性チェックや制約付き関数合成などに応用可能

-}






-- 有限写像
data FiniteMapping a b = FiniteMapping {
  table :: [(a, b)]
}


-- 写像の性質を明示的に保持・検査
data MappingProperty = Injective | Surjective | Bijective

data Mapping a b = Mapping {
  apply :: a -> b,
  domain :: [a],
  codomain :: [b],
  properties :: [MappingProperty]
}
