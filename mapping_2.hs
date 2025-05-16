-- Mapping を型クラスで抽象化
class Mapping f where
  type Domain f
  type Codomain f
  apply :: f -> Domain f -> Codomain f
