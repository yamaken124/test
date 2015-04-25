[
  { id: 1, user_category_id: 1, taxon_id: 2 },
  { id: 2, user_category_id: 1, taxon_id: 3 },
  { id: 3, user_category_id: 1, taxon_id: 4 },
  { id: 4, user_category_id: 2, taxon_id: 2 },
  { id: 5, user_category_id: 2, taxon_id: 3 },
  { id: 6, user_category_id: 2, taxon_id: 4 },
  { id: 7, user_category_id: 2, taxon_id: 6 },
  { id: 8, user_category_id: 3, taxon_id: 2 },
  { id: 9, user_category_id: 3, taxon_id: 3 },
  { id: 10, user_category_id: 3, taxon_id: 4 },
  { id: 11, user_category_id: 3, taxon_id: 6 },
  { id: 12, user_category_id: 3, taxon_id: 8 },
  ].each { |s| UserCategoriesTaxon.seed(s) }
