%{
  site_name: "Maartz",
  site_description: "Software developer",
  date_format: "{WDfull}, {D} {Mshort} {YYYY}",
  base_url: "/",
  author: "Maartz",
  author_email: "maartz@protonmail.com",
  plugins: [
    {Serum.Plugins.LiveReloader, only: :dev}
  ],
  theme: Serum.Themes.Essence,
}
