return {
  name = "prisma generate",
  builder = function()
    return {
      cmd = { "pnpm", "--filter", "@atlantis/db", "db:generate" },
    }
  end,
}
