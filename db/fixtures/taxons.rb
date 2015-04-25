[
  { id: 1, name: '全てのカテゴリ', position: 1 },
  { id: 2, name: 'サプリメント',   position: 1, parent_id: 1 },
  { id: 3, name: '検査',           position: 2, parent_id: 1 },
  { id: 4, name: 'ドリンク',       position: 3, parent_id: 1 },
  { id: 5, name: '限定販売商品',       position: 1},
  { id: 6, name: '弁当',       position: 1, parent_id: 5},
  { id: 7, name: '1回限り商品',       position: 1},
  { id: 8, name: 'クーポン券',       position: 1, parent_id: 7},
].each { |s| Taxon.seed(s) }
