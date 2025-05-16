-- Mapping を型クラスで抽象化
class Mapping f where
  type Domain f
  type Codomain f
  apply :: f -> Domain f -> Codomain f

-- 拡張された構造付き写像
data Mapping a b = Mapping {
  apply     :: a -> b,
  domainSet :: a -> Bool,    -- 属するかどうか（∞集合でもOK）
  codomainSet :: b -> Bool   -- 値域として含まれるか
}
