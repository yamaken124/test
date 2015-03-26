[
  { id: 1, name: '全てのカテゴリ', position: 1 },
  { id: 2, name: 'サプリメント',   position: 2, parent_id: 1 },
  { id: 3, name: '検査',           position: 3, parent_id: 1 },
  { id: 4, name: 'ドリンク',       position: 4, parent_id: 1 }
].each { |s| Taxon.seed(s) }
