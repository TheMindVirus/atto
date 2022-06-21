robot = require("robot")
sides = require("sides")
nav = require("component").navigation
simulation = 0
jump = 0

des1gn = [[
F2,MD,F1,X3
]]

design = [[
//[Inventory]
//1 - Redstone Dust
//2 - Redstone Lamp
//3 - Redstone Torch
//4 - Redstone Repeater
//5 - Redstone Lever
//6 - Sticky Piston

//[Instructions] //Intended for Creatix
F2,MD,PD1,F1,X3 //Clock Strobe
F1,R2,U1,PD1 //Clock Strobe Wire
F1,PD1,F2,PD1,X3 //Clock Strobe Wire
L1,F1,L1,PD2 //Lamps
F3,PD2,X3 //Lamps
F2,D1,L2,PF3 //Torches
U1,F3,D1,PF3,X3 //Torches
U2,F2,R2,PD1 //Wire
F3,PD1,X3 //Wire

F1,R1,F1,D1 //Alignment
PD4,R1,F1,L1,PD4,R1,F2,L1,X4 //Repeaters
D1,B1,L1,PF5,R1,F2,L1,U1,F2 //Lever
PD4,F1,PD4,F1,PD2,F1,X3 //Repeaters and Lamps
PD4,F1,PD4,F1,PD2,L2,U1 //Repeaters and Lamps
PD1,F3,X4 //Wire
D1,L1 //Alignment
PD1,F1,X2 //Wire
L1,D1,PF2,B1,PF5,U1,F1 //Lever
F2,L1,PD4,F1,PD1,R1,F1,PD1,R1,F1,PD4,L1,X3 //Repeaters and Wire
F2,L1,PD4,F1,PD1,R1,F1,PD1,R1,F1,PD4,F2 //Repeaters and Wire
PD4,F1,R1,PD2,F1,PD2,R1,F1,PD4,L1,F2,L1,X3 //Repeaters and Lamps
PD4,F1,R1,PD2,F1,PD2,R1,F1,PD4,F1,R1 //Repeaters and Lamps

PD2,U1,X3
PD2,F1
R2,D2 // :)
D2,MF
U1,MF,X2 //Self-Remove Support
B1,U1
PF2,B1,X9
PF2,D2,F1
PU6,F1,PU6,F2,X3 //Sticky Pistons
PU6,F1,PU6,F1
L2,U2,
MF,F1,X11 //Self-Remove Support
F1
R2,D2 # :)
D2

F1,PU2,F1,PU2,F1,X4 //Lamps
U2,R1,F2,R1,F1,R1,PF2
L1,F3,R1,PF2,X3
U2,F1,R1,PD5 //Levers
F3,PD5,X3
L1,F3,L1,F1,L1,D2,PF2 //Lamps
R1,F3,L1,PF2,X3
U2,F1,L1,PD5 //Levers
F3,PD5,X3
F2,L1,F3,D4,L1,MD,D1 //Dig Down
MR,MF,F1,X11
R1,MF,F1,L1,U1
PD2,U1,PD2,B2,D2,PF3,U1,PF2,B1,PF5,TF2,X4 // :)
U2,F2

PD1,F1,PD1,F2,X3
PD1,F1,PD1,L1,F1,L1,D2,PD1
F3,PD1,X3
F1,L1,B1,PF3
L1,F3,R1,PF3,X3 //Torches
U1,R1,B1,PD1
F3,PD1,X3
F1,R1,PD4
R1,F3,L1,PD4,X3 //Repeaters
U1,F1,L1,B1
PD1,F1,PD1,F2,X4
R1
F1,X8
R1,D1
]]

-- Not Happy About This Being Missing --

function replace(data, old, dat)
  return string.gsub(data, "["..old.."]", dat)
end

function comment(data, sep)
  dat = data
  pos = string.find(dat, sep)
  if pos ~= nil then
    dat = string.sub(dat, 0, pos - 1)
  end
  return dat
end

function trim(data)
  dat = data
  dat = replace(dat, " ", "")
  dat = comment(dat, "#")
  dat = comment(dat, "/")
  dat = comment(dat, "-")
  return dat
end

function split(data, sep)
  dat = {}
  off = 0
  pos = data:find(sep)
  while pos ~= nil do
    table.insert(dat, data:sub(off, pos - 1))
    off = pos + 1
    pos = data:find(sep, off)
  end
  table.insert(dat, data:sub(off, data:len()))
  return dat
end

function geta(way)
  side = nil
  if way == "F" then side = sides.front
  elseif way == "B" then side = sides.back
  elseif way == "L" then side = sides.left
  elseif way == "R" then side = sides.right
  elseif way == "U" then side = sides.up
  elseif way == "D" then side = sides.down
  else print("Unknown way" .. tostring(way)) end
  return side
end

function seta(side)
  way = "?"
  if side == sides.front then way = "F"
  elseif side == sides.back then way = "B"
  elseif side == sides.left then way = "L"
  elseif side == sides.right then way = "R"
  elseif side == sides.up then way = "U"
  elseif side == sides.down then way = "D"
  else print("Unknown side" .. tostring(side)) end
  return way
end

function wrench(slot)
  if slot == 4 then
    side = nav.getFacing()
    mul = 0
    if side == sides.right then mul = 1
    elseif side == sides.back then mul = 2
    elseif side == sides.left then mul = 3
    end
    for i = 1,mul do robot.useDown() end
  end
end

function mine(side) 
  if side == sides.front then robot.swing()
  elseif side == sides.down then robot.swingDown()
  elseif side == sides.up then robot.swingUp()
  elseif side == sides.left then
    robot.turnLeft()
    robot.swing()
    robot.turnRight()
  elseif side == sides.right then
    robot.turnRight()
    robot.swing()
    robot.turnLeft()
  elseif side == sides.back then
    robot.turnRight()
    robot.turnRight()
    robot.swing()
    robot.turnLeft()
    robot.turnLeft()
  else print("[WARN]: mine unknown side?") end
end

function place(side, slot)
  robot.select(slot)
  if side == sides.front then robot.place()
  elseif side == sides.down then
    robot.placeDown()
    wrench(slot)
  elseif side == sides.up then robot.placeUp()
  elseif side == sides.left then
    robot.turnLeft()
    robot.place()
    robot.turnRight()
  elseif side == sides.right then
    robot.turnRight()
    robot.place()
    robot.turnLeft()
  elseif side == sides.back then
    robot.turnLeft()
    robot.turnLeft()
    robot.place()
    robot.turnRight()
    robot.turnRight()
  else print("[WARN]: place unknown side?") end
  robot.select(1)
end

function toggle(side, mul)
  if side == sides.front then
    for i = 1,mul do robot.use() end
  elseif side == sides.down then
    for i = 1,mul do robot.useDown() end
  elseif side == sides.up then
    for i = 1,mul do robot.useUp() end
  elseif side == sides.left then
    robot.turnLeft()
    for i = 1,mul do robot.use() end
    robot.turnRight()
  elseif side == sides.right then
    robot.turnRight()
    for i = 1,mul do robot.use() end
    robot.turnLeft()
  elseif side == sides.back then
    robot.turnLeft()
    robot.turnLeft()
    for i = 1,mul do robot.use() end
    robot.turnRight()
    robot.turnRight()
  else print("[WARN]: toggle unknown side?") end
end

function interpret(dat, sim, rec)
  dat = string.upper(trim(dat))
  cmd = string.sub(dat, 1, 1)
  if cmd == "F" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 0 then
      if sim == 0 then
        for i = 1,mul do robot.forward() end
      else print(cmd .. tostring(mul)) end
    end
  elseif cmd == "B" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 0 then
      if sim == 0 then
        for i = 1,mul do robot.back() end
      else print(cmd .. tostring(mul)) end
    end
  elseif cmd == "L" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 0 then
      if sim == 0 then
        for i = 1,mul do robot.turnLeft() end
      else print(cmd .. tostring(mul)) end
    end
  elseif cmd == "R" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 0 then
      if sim == 0 then
        for i = 1,mul do robot.turnRight() end
      else print(cmd .. tostring(mul)) end
    end
  elseif cmd == "U" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 0 then
      if sim == 0 then
        for i = 1,mul do robot.up() end
      else print(cmd .. tostring(mul)) end
    end
  elseif cmd == "D" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 0 then
      if sim == 0 then
        for i = 1,mul do robot.down() end
      else print(cmd .. tostring(mul)) end
    end
  elseif cmd == "M" then
    way = string.sub(dat, 2, 2)
    side = geta(way)
    if sim == 0 then
      if side ~= nil then mine(side) end
    else print(cmd .. seta(side)) end
  elseif cmd == "P" then
    way = string.sub(dat, 2, 2)
    side = geta(way)
    slot = tonumber(string.sub(dat, 3))
    if sim == 0 then
      if side ~= nil then place(side, slot) end
    else print(cmd .. seta(side) .. tostring(slot)) end
  elseif cmd == "T" then
    way = string.sub(dat, 2, 2)
    side = geta(way)
    mul = tonumber(string.sub(dat, 3))
    if sim == 0 then
      if side ~= nil and mul > 0 then
        toggle(side, mul)
      end
    else print(cmd .. seta(side) .. tostring(mul)) end
  elseif cmd == "X" then
    mul = tonumber(string.sub(dat, 2))
    if mul > 1 and rec == 0 then
      jump = mul - 1
    end
  end
end

function build(data, sim)
  lines = split(data, "\n")
  for i,v in pairs(lines) do
    tokens = split(v, ",")
    for j,t in pairs(tokens) do
      interpret(t, sim, 0)
      while jump > 0 do
        for k,d in pairs(tokens) do
          interpret(d, sim, 1)
        end
        jump = jump - 1
      end
    end
  end
end

build(design, simulation)