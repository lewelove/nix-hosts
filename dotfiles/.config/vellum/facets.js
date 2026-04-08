export const facets = {
  collection: {
    label: "Collection",
    getValue: (a) => a.tags?.COLLECTION
  },
  discs: {
    label: "Total Discs",
    getValue: (a) => String(a.total_discs || 1)
  }
};
