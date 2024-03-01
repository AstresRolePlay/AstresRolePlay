surface.CreateFont("Escape", {font = "Inria Sans Light", size = 30, extended = true})
surface.CreateFont("TitreEscape", {font = "Inria Sans Light", size = 50, extended = true})


--[[------------------------------
    Rounded Graduer 
--------------------------------]]
function drawHorizontalGradient(x, y, w, h, color1, color2)
    local gradientSteps = 200

    for i = 0, gradientSteps do
        local gradientFactor = i / gradientSteps

        local gradientColor = Color(
            Lerp(gradientFactor, color1.r, color2.r),
            Lerp(gradientFactor, color1.g, color2.g),
            Lerp(gradientFactor, color1.b, color2.b),
            Lerp(gradientFactor, color1.a, color2.a)
        )

        draw.RoundedBoxEx(8, x + w * gradientFactor, y, w / gradientSteps, h, gradientColor, false, true, false, true)
    end
end


--[[------------------------------
    Text assombrie
--------------------------------]]

function drawAncientText(text, font, x, y, color)
    surface.SetFont(font)
    local textWidth, textHeight = surface.GetTextSize(text)

    draw.SimpleText(text, font, x, y, color)
    draw.SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0, color.a / 2)) 
end