return {
  name = "kill nodes",
  builder = function()
    return {
      cmd = { "sh", "-c", "ps -u cocaine -o pid,cgroup,args | grep '[n]ode' | grep 'user.slice' | awk '{print $1}' | xargs -r kill; true" },
    }
  end,
}
