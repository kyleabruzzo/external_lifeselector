return {
    Debug = {
        enabled = true,
        command = 'lifeselector'
    },

    Cutscene = {
        fadeInTime = 1000,
        fadeOutTime = 1000,
        prepareTime = 1000
    },

    Paths = {
        racing = {
            id = "racing",
            title = "Street Racing Elite",
            description = "Join the high-stakes world of illegal street racing.",
            mentor = "Hao",
            image = "https://cdn.mos.cms.futurecdn.net/NSqrsZ5LgZSamuyceRENw9.jpg", 
            scenario = "Hao has noticed your driving skills and wants to meet at the LS Car Meet. He might have a special vehicle waiting for you...",
            spawnLocation = vector4(782.93, -1867.95, 29.29, 78.92),
            cutscene = {
                name = "tun_meet_int",
                duration = 30000,
                weather = "CLEAR",
                coords = vector3(-2201.717, 1132.0045, -23.26399),
                time = {hour = 21, minute = 0},
            },
            items = {
                {name = 'radio', label = 'Phone', amount = 1},
                {name = 'armour', label = 'Repair Kit', amount = 1}
            }
        },
    }
}