function test(){
    shifts = [["2022-03-10", "6:00", "14:00"], ["2022-03-10", "6:00", "12:00"]];
    return productivityCalculator(1000, "2022-03-10", "2022-03-10", "6:00", "12:00", shifts);
}

//console.log(test());

function productivityCalculator(profit, startDate, endDate, startTime, endTime, shifts){
    /*
    startDate format - '0000:00:00'
    endDate format - '0000:00:00'
    startTime format - '00:00'
    endTime format - '00:00'
    */
    profit = parseInt(profit);
    let hours = 0.0;
    shifts = getDates(shifts, startDate, endDate);
    for (i = 0; i < shifts.length; i++){
        hours += getHours(shifts[i], startTime, endTime);
    }
    return(profit/hours);
}

function getDates(shifts, startDate, endDate){
    let newShifts = [];
    for(i = 0; i < shifts.length; i++){
        if(shifts[i][0] <= startDate || shifts[i][0] >= endDate){
            newShifts.push(shifts[i]);
        }
    }
    return newShifts
}

function getHours(shift, startTime, endTime){
    /*
    Helper method for productivityCalculator
    */
    let shiftStart = shift[1].split(':');
    shiftStart = [parseInt(shiftStart[0]), parseInt(shiftStart[1])];
    let shiftEnd = shift[2].split(':');
    shiftEnd = [parseInt(shiftEnd[0]), parseInt(shiftEnd[1])];
    let start = startTime.split(':');
    start = [parseInt(start[0]), parseInt(start[1])];
    let end = endTime.split(':');
    end = [parseInt(end[0]), parseInt(end[1])];
    if(shiftStart[0] > end[0] || (shiftStart[0] == end[0] && shiftStart[1] > end[1]) || shiftEnd[0] < start[0] || (shiftEnd[0] == start[0] && shiftEnd[1] < start[1])){
        // if the start of the shift is after the desired end OR the end of the shift is before the desired start, then no need to check hours
        return 0.0;
    }
    if(shiftStart[0] < start[0] || (shiftStart[0] == start[0] && shiftStart[1] < start[1])){
        // if the start of the shift is before the desired start, then adjust to only use the hours during the desired shift
        shiftStart[0] = start[0];
        shiftStart[1] = start[1];
    }
    if(shiftEnd[0] > end[0] || (shiftEnd[0] == end[0] && shiftEnd[1] > end[1])){
        // if the end of the shift is after the desired end, then adjust to only use the hours during the desired shift
        shiftEnd[0] = end[0];
        shiftEnd[1] = end[1];
    }
    let startMinute = shiftStart[0]*60 + shiftStart[1];
    let endMinute = shiftEnd[0]*60 + shiftEnd[1];
    return (endMinute - startMinute)/60;
}