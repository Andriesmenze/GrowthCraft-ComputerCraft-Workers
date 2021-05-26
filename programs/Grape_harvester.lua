errorLevel1Count = 0
errorLevel2Count = 0
function nextLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
end
function turnAround()
    turtle.turnLeft()
    os.sleep(1)
    turtle.turnLeft()
end
function checkBlock()
    success, data = turtle.inspect()
    if success == true then
        block = data.name
        return block
    else
        success, data = turtle.inspect()
        if success == true then
            block = data.name
            return block
        else
            return false
        end
    end
end
function getItemIndex(itemName)
    for slot = 1, 16, 1 do
        item = turtle.getItemDetail(slot)
        if item ~= nil then
            if item.name == itemName then
                return slot
            end
        end
    end
end
function fuel()
    fuelLevel = turtle.getFuelLevel()
    if fuelLevel < 100 then
        print("")
        print("Fuel Low")
        print("Fuel Level : "..fuelLevel)
        fuelSlot = getItemIndex("minecraft:coal_block")
        if fuelSlot ~= false then
            turtle.select(fuelSlot)
            turtle.refuel()
        else
            print("Inventory out of Fuel")
            print("Stopping in "..fuelLevel.." Moves")
        end
    end
end
function harvest()
    turtle.dig()
end
print("starting....")
while true do
    fuel()
    os.sleep(1)
    nextLeft()
    print("moving over")
    os.sleep(1)
    inFrontBlock = checkBlock()
    if inFrontBlock ~= false then
        if inFrontBlock == "Growthcraft|Grapes:grc.grapeBlock" then
            errorLevel1Count = 0
            errorLevel2Count = 0
            print("Grape detected")
            harvest()
        elseif inFrontBlock == "minecraft:fence" then
            errorLevel1Count = 0
            errorLevel2Count = 0
            print("detected a fence turning around")
            print("")
            turnAround()
        else
            nextLeft()
        end
    else
        errorLevel1Count = errorLevel1Count + 1
        if errorLevel1Count >= 20 then
            turtle.turnLeft()
            errorLevel2Count = errorLevel2Count + 1
            if errorLevel2Count >= 2 then
                break
            end
        end
    end
end