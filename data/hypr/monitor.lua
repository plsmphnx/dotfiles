local real = {
    { "Tianma Microelectronics Ltd. TL070FDXS01",  -480,     0, 2 },
    { "Dell Inc. DELL U2719D 8QCLRS2",            -1024, -1152, 1.25 },
    { "Dell Inc. DELL U2719D 6SCLRS2",             1024, -1450, 1.25, 1 },
    { "HP Inc. HP 25x CNK0222MF8",                 -960, -1080 },
    { "LG Electronics LG PROJECTOR 0x01010101",   -2880, -1080 },
}

local fake = {
    { "pine", 1920, 1080, 1.5 },
    { "desk", 1920, 1080 },
    { "tab",  2560, 1536, 2 },
}

for _, mon in ipairs(real) do
    monitor.add {
        output = "desc:" .. mon[1],
        mode = "preferred",
        position = mon[2] .. "x" .. mon[3],
        scale = mon[4] or "auto",
        transform = mon[5] or 0,
    }
end

for _, mon in ipairs(fake) do
    monitor.add {
        output = mon[1],
        mode = mon[2] .. "x" .. mon[3] .. "@30",
        position = "auto",
        scale = mon[4] or "auto",
        transform = mon[5] or 0,
    }
end
