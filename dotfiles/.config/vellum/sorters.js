export const sorters = {
  last_edited: {
    label: "Last Edited",
    sort: (a, b) => (b.metadata_toml_mtime || 0) - (a.metadata_toml_mtime || 0)
  }
};
