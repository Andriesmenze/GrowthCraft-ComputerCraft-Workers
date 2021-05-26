errorLevelCount = 0
function checkBlockDown()
    success, data = turtle.inspectDown()
    if success == true then
        block = data.name
        state = data.metadata
        return block, state
    else
        return false
    end
end
function checkBlock()
    success, data = turtle.inspect()
    if success == true then
        block = data.name
        return block
    else
        return false
    end
end
function getItemIndex(itemName)
    for slot = 1, 16, 1 do
        item = turtle.getItemDetail(slot)
        if item ~= nil then
            if item.name == itemName then
                return slot
            end
        else
            return false
        end
    end
end
function placeWater()
    print("Placing Water")
    turtle.select(getItemIndex("AWWayofTime:waterSigil"))
    turtle.placeDown()
    os.sleep(1)
    turtle.down()
    os.sleep(1)
    turtle.up()
end
function harvestReady()
    if state == 7 then
        return true
    else
        return false
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
    print("Harvesting")
    turtle.digDown()
end
function makePlantReady()
    if checkBlockDown() == false then
        turtle.down()
        name, state = checkBlockDown()
        if name == "minecraft:dirt" then
            print("This block is not RiceFarm ready")
            turtle.up()
            return false
        elseif name == "Growthcraft|Rice:grc.paddyField" and state ~= 7 then
            turtle.up()
            placeWater()
            return true 
        else
            turtle.up()
            return true 
        end
    end
end
function plant()
    riceSlot = getItemIndex("Growthcraft|Rice:grc.rice")
    if riceSlot ~= false then
        print("Planting")
        turtle.select(riceSlot)
        turtle.placeDown()
    else
        print("Out of Rice")
    end
end
function turnAround()
    turtle.turnLeft()
    os.sleep(1)
    turtle.turnLeft()
end
function next()
    frontBlock = checkBlock()
    if frontBlock == "minecraft:fence" or frontBlock == "Growthcraft:grc.fenceRope" then
        print("detected a fence turning around")
        print("")
        turnAround()
        turtle.forward()
    else
        print("Moving forward")
        if errorLevelCount >= 20 then
            print("can't move forward")
            return false
        else
            if turtle.forward() ~= true then
                print("can't move forward")
                errorLevelCount = errorLevelCount + 1
            else
                errorLevelCount = 0
            end
        end
    end
end
print("starting....")
while true do
    fuel()
    if turtle.getFuelLevel() == 0 then
        print("Stopping")
        break
    end
    downBlockName, downBlockState = checkBlockDown()
    if downBlockName ~= false then
        if harvestReady() == false then
            if next() == false then
                break
            end
        else
            print("")
            harvest()
            os.sleep(1)
            if makePlantReady() ~= false then
                os.sleep(1)
                plant()
            end
            print("")
            os.sleep(1)
            if next() == false then
                break
            end
        end
    else
        makePlantReady()
        os.sleep(1)
        plant()
        os.sleep(1)
        if next() == false then
            print("Closing Program, can't move forward")
            break
        end
    end
end