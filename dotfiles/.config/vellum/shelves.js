export const shelves = {
  my_year: {
    label: "My Year",
    filter: (a) => a.tags?.MY_YEAR
  },
  youtube: {
    label: "YouTube Collection",
    filter: (a) => a.tags?.UNIX_ADDED_YOUTUBE
  },
  apple_music: {
    label: "Apple Music Collection",
    filter: (a) => a.tags?.UNIX_ADDED_APPLEMUSIC
  },
  foobar: {
    label: "Foobar2000 Collection",
    filter: (a) => a.tags?.UNIX_ADDED_FOOBAR
  },
  vapor_memory: {
    label: "Vapor Memory",
    filter: (a) => {
      const col = a.tags?.COLLECTION;
      if (Array.isArray(col)) return col.includes("Vapor Memory");
      return col === "Vapor Memory";
    }
  }
};
