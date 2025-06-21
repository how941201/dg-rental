local Translations = {
    bilp = {
        lable = 'Do Do Good Car Rental',
    },
    error = {
        not_enough_money = 'You dont have enough money',
        nospotfound = 'No space left',
        time_up = 'The rental period has expired and the vehicle has been reclaimed'
    },
    menu = {
        rent_time_title = 'Select rental time',
        day = 'Day',
        rent = 'Rent'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})