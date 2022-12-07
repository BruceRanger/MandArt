//
//  LookupOptimizedForPrintColor.swift
//  MandArt
//
//

import Foundation

/// A quick lookup dictionary
///  Given a user-input RGB color likely to print poorly
///   Provide an RGB color optimized for printing
///   TODO: Fix entries - this test will make two dark blue entries change to white for optimized printing
let LookupOptimizedForPrintColor = [
    "000-000-255":"255-255-255",
    "000-000-250":"255-255-255",

    // Block (Red = 0)

    // row 1 (6)
    "000-102-000":"255-255-255", // g4
    "000-136-000":"255-255-255", // g5
    "000-170-000":"255-255-255", // g6
    "000-204-000":"255-255-255", // g7
    "000-238-000":"255-255-255", // g8
    "000-255-000":"255-255-255", // g9

    // row 2 (5)
    "000-136-034":"255-255-255", // g5
    "000-170-034":"255-255-255", // g6
    "000-204-034":"255-255-255", // g7
    "000-238-034":"255-255-255", // g8
    "000-255-034":"255-255-255", // g9

    // row 3 (4)
    "000-170-068":"255-255-255", // g6
    "000-204-068":"255-255-255", // g7
    "000-238-068":"255-255-255", // g8
    "000-255-068":"255-255-255", // g9

    // row 4 (4)
    "000-000-102":"255-255-255", // g1
    "000-204-102":"255-255-255", // g7
    "000-238-102":"255-255-255", // g8
    "000-255-102":"255-255-255", // g9

    // row 5 (5)
    "000-000-136":"255-255-255", // g1
    "000-034-136":"255-255-255", // g2
    "000-204-136":"255-255-255", // g7
    "000-238-136":"255-255-255", // g8
    "000-255-136":"255-255-255", // g9

    // row 6 (6)
    "000-000-170":"255-255-255", // g1
    "000-034-170":"255-255-255", // g2
    "000-068-170":"255-255-255", // g3
    "000-204-170":"255-255-255", // g7
    "000-238-170":"255-255-255", // g8
    "000-255-170":"255-255-255", // g9

    // row 7 (all 9)
    "000-000-204":"255-255-255", // g1
    "000-034-204":"255-255-255", // g2
    "000-068-204":"255-255-255", // g3
    "000-102-204":"255-255-255", // g4
    "000-136-204":"255-255-255", // g5
    "000-170-204":"255-255-255", // g6
    "000-204-204":"255-255-255", // g7
    "000-238-204":"255-255-255", // g8
    "000-255-204":"255-255-255", // g9

    // row 8 (8)
    "000-000-238":"255-255-255", // g1
    "000-034-238":"255-255-255", // g2
    "000-068-238":"255-255-255", // g3
    "000-102-238":"255-255-255", // g4
    "000-136-238":"255-255-255", // g5
    "000-170-238":"255-255-255", // g6
    "000-238-238":"255-255-255", // g8
    "000-255-238":"255-255-255", // g9

    // row 9 (all 9)
    "000-000-255":"255-255-255", // g1
    "000-034-255":"255-255-255", // g2
    "000-068-255":"255-255-255", // g3
    "000-102-255":"255-255-255", // g4
    "000-136-255":"255-255-255", // g5
    "000-170-255":"255-255-255", // g6
    "000-204-255":"255-255-255", // g7
    "000-238-255":"255-255-255", // g8
    "000-255-255":"255-255-255", // g9

    // Block (Red = 34)

    // row 1 (5)
    "034-136-000":"255-255-255", // g5
    "034-170-000":"255-255-255", // g6
    "034-204-000":"255-255-255", // g7
    "034-238-000":"255-255-255", // g8
    "034-255-000":"255-255-255", // g9

    // row 2 (4)
    "034-170-034":"255-255-255", // g6
    "034-204-034":"255-255-255", // g7
    "034-238-034":"255-255-255", // g8
    "034-255-034":"255-255-255", // g9

    // row 3 (3)
    "034-204-068":"255-255-255", // g7
    "034-238-068":"255-255-255", // g8
    "034-255-068":"255-255-255", // g9

    // row 4 (3)
    "034-204-102":"255-255-255", // g7
    "034-238-102":"255-255-255", // g8
    "034-255-102":"255-255-255", // g9

    // row 5 (3)
    "034-204-136":"255-255-255", // g7
    "034-238-136":"255-255-255", // g8
    "034-255-136":"255-255-255", // g9

    // row 6 (2)
    "034-238-170":"255-255-255", // g8
    "034-255-170":"255-255-255", // g9

    // row 7 (7)
    "034-000-204":"255-255-255", // g1
    "034-034-204":"255-255-255", // g2
    "034-068-204":"255-255-255", // g3
    "034-102-204":"255-255-255", // g4
    "034-204-204":"255-255-255", // g7
    "034-238-204":"255-255-255", // g8
    "034-255-204":"255-255-255", // g9

    // row 8 (8)
    "034-000-238":"255-255-255", // g1
    "034-034-238":"255-255-255", // g2
    "034-068-238":"255-255-255", // g3
    "034-102-238":"255-255-255", // g4
    "034-136-238":"255-255-255", // g5
    "034-170-238":"255-255-255", // g6
    "034-238-238":"255-255-255", // g8
    "034-255-238":"255-255-255", // g9

    // row 9 (all 9)
    "034-000-255":"255-255-255", // g1
    "034-034-255":"255-255-255", // g2
    "034-068-255":"255-255-255", // g3
    "034-102-255":"255-255-255", // g4
    "034-136-255":"255-255-255", // g5
    "034-170-255":"255-255-255", // g6
    "034-204-255":"255-255-255", // g7
    "034-238-255":"255-255-255", // g8
    "034-255-255":"255-255-255", // g9

    // Block (Red = 68)

    // row 1 (4)
    "068-170-000":"255-255-255", // g6
    "068-204-000":"255-255-255", // g7
    "068-238-000":"255-255-255", // g8
    "068-255-000":"255-255-255", // g9

    // row 2 (3)
    "068-204-034":"255-255-255", // g7
    "068-238-034":"255-255-255", // g8
    "068-255-034":"255-255-255", // g9

    // row 3 (3)
    "068-204-068":"255-255-255", // g7
    "068-238-068":"255-255-255", // g8
    "068-255-068":"255-255-255", // g9

    // row 4 (3)
    "068-204-102":"255-255-255", // g7
    "068-238-102":"255-255-255", // g8
    "068-255-102":"255-255-255", // g9

    // row 5 (3)
    "068-204-136":"255-255-255", // g7
    "068-238-136":"255-255-255", // g8
    "068-255-136":"255-255-255", // g9

    // row 6 (2)
    "068-238-170":"255-255-255", // g8
    "068-255-170":"255-255-255", // g9

    // row 7 (7)
    "068-000-204":"255-255-255", // g1
    "068-034-204":"255-255-255", // g2
    "068-068-204":"255-255-255", // g3
    "068-102-204":"255-255-255", // g4
    "068-204-204":"255-255-255", // g7
    "068-238-204":"255-255-255", // g8
    "068-255-204":"255-255-255", // g9

    // row 8 (8)
    "068-000-238":"255-255-255", // g1
    "068-034-238":"255-255-255", // g2
    "068-068-238":"255-255-255", // g3
    "068-102-238":"255-255-255", // g4
    "068-136-238":"255-255-255", // g5
    "068-170-238":"255-255-255", // g6
    "068-238-238":"255-255-255", // g8
    "068-255-238":"255-255-255", // g9

    // row 9 (all 9)
    "068-000-255":"255-255-255", // g1
    "068-034-255":"255-255-255", // g2
    "068-068-255":"255-255-255", // g3
    "068-102-255":"255-255-255", // g4
    "068-136-255":"255-255-255", // g5
    "068-170-255":"255-255-255", // g6
    "068-204-255":"255-255-255", // g7
    "068-238-255":"255-255-255", // g8
    "068-255-255":"255-255-255", // g9

    // Block (Red = 102)

    // row 1 (4)
    "102-170-000":"255-255-255", // g6
    "102-204-000":"255-255-255", // g7
    "102-238-000":"255-255-255", // g8
    "102-255-000":"255-255-255", // g9

    // row 2 (4)
    "102-170-034":"255-255-255", // g6
    "102-204-034":"255-255-255", // g7
    "102-238-034":"255-255-255", // g8
    "102-255-034":"255-255-255", // g9

    // row 3 (3)
    "102-204-068":"255-255-255", // g7
    "102-238-068":"255-255-255", // g8
    "102-255-068":"255-255-255", // g9

    // row 4 (3)
    "102-204-102":"255-255-255", // g7
    "102-238-102":"255-255-255", // g8
    "102-255-102":"255-255-255", // g9

    // row 5 (3)
    "102-204-136":"255-255-255", // g7
    "102-238-136":"255-255-255", // g8
    "102-255-136":"255-255-255", // g9

    // row 6 (2)
    "102-238-170":"255-255-255", // g8
    "102-255-170":"255-255-255", // g9

    // row 7 (6)
    "102-000-204":"255-255-255", // g1
    "102-034-204":"255-255-255", // g2
    "102-068-204":"255-255-255", // g3
    "102-102-204":"255-255-255", // g4
    "102-238-204":"255-255-255", // g8
    "102-255-204":"255-255-255", // g9

    // row 8 (8)
    "102-000-238":"255-255-255", // g1
    "102-034-238":"255-255-255", // g2
    "102-068-238":"255-255-255", // g3
    "102-102-238":"255-255-255", // g4
    "102-136-238":"255-255-255", // g5
    "102-170-238":"255-255-255", // g6
    "102-238-238":"255-255-255", // g8
    "102-255-238":"255-255-255", // g9

    // row 9 (all 9)
    "102-000-255":"255-255-255", // g1
    "102-034-255":"255-255-255", // g2
    "102-068-255":"255-255-255", // g3
    "102-102-255":"255-255-255", // g4
    "102-136-255":"255-255-255", // g5
    "102-170-255":"255-255-255", // g6
    "102-204-255":"255-255-255", // g7
    "102-238-255":"255-255-255", // g8
    "102-255-255":"255-255-255", // g9

    // Block (Red = 136)

    // row 1 (3)
    "136-204-000":"255-255-255", // g7
    "136-238-000":"255-255-255", // g8
    "136-255-000":"255-255-255", // g9

    // row 2 (3)
    "136-204-034":"255-255-255", // g7
    "136-238-034":"255-255-255", // g8
    "136-255-034":"255-255-255", // g9

    // row 3 (2)
    "136-238-068":"255-255-255", // g8
    "136-255-068":"255-255-255", // g9

    // row 4 (3)
    "136-204-102":"255-255-255", // g7
    "136-238-102":"255-255-255", // g8
    "136-255-102":"255-255-255", // g9

    // row 5 (3)
    "136-204-136":"255-255-255", // g7
    "136-238-136":"255-255-255", // g8
    "136-255-136":"255-255-255", // g9

    // row 6 (2)
    "136-238-170":"255-255-255", // g8
    "136-255-170":"255-255-255", // g9

    // row 7 (6)
    "136-000-204":"255-255-255", // g1
    "136-034-204":"255-255-255", // g2
    "136-068-204":"255-255-255", // g3
    "136-102-204":"255-255-255", // g4
    "136-238-204":"255-255-255", // g8
    "136-255-204":"255-255-255", // g9

    // row 8 (8)
    "136-000-238":"255-255-255", // g1
    "136-034-238":"255-255-255", // g2
    "136-068-238":"255-255-255", // g3
    "136-102-238":"255-255-255", // g4
    "136-136-238":"255-255-255", // g5
    "136-170-238":"255-255-255", // g6
    "136-238-238":"255-255-255", // g8
    "136-255-238":"255-255-255", // g9

    // row 9 (8)
    "136-000-255":"255-255-255", // g1
    "136-034-255":"255-255-255", // g2
    "136-068-255":"255-255-255", // g3
    "136-102-255":"255-255-255", // g4
    "136-136-255":"255-255-255", // g5
    "136-170-255":"255-255-255", // g6
    "136-238-255":"255-255-255", // g8
    "136-255-255":"255-255-255", // g9

    // Block (Red = 170)

    // row 1 (3)
    "170-204-000":"000-000-000", // g7
    "170-238-000":"000-000-000", // g8
    "170-255-000":"000-000-000", // g9

    // row 2 (3)
    "170-204-034":"000-000-000", // g7
    "170-238-034":"000-000-000", // g8
    "170-255-034":"000-000-000", // g9

    // row 3 (3)
    "170-204-068":"000-000-000", // g7
    "170-238-068":"000-000-000", // g8
    "170-255-068":"000-000-000", // g9

    // row 4 (3)
    "170-204-102":"000-000-000", // g7
    "170-238-102":"000-000-000", // g8
    "170-255-102":"000-000-000", // g9

    // row 5 (2)
    "170-238-136":"000-000-000", // g8
    "170-255-136":"000-000-000", // g9

    // row 6 (2)
    "170-238-170":"000-000-000", // g8
    "170-255-170":"000-000-000", // g9

    // row 7 (6)
    "170-000-204":"000-000-000", // g1
    "170-034-204":"000-000-000", // g2
    "170-068-204":"000-000-000", // g3
    "170-102-204":"000-000-000", // g4
    "170-238-204":"000-000-000", // g8
    "170-255-204":"000-000-000", // g9

    // row 8 (7)
    "170-000-238":"000-000-000", // g1
    "170-034-238":"000-000-000", // g2
    "170-068-238":"000-000-000", // g3
    "170-102-238":"000-000-000", // g4
    "170-136-238":"000-000-000", // g5
    "170-170-238":"000-000-000", // g6
    "170-255-238":"000-000-000", // g9

    // row 9 (8)
    "170-000-255":"000-000-000", // g1
    "170-034-255":"000-000-000", // g2
    "170-068-255":"000-000-000", // g3
    "170-102-255":"000-000-000", // g4
    "170-136-255":"000-000-000", // g5
    "170-170-255":"000-000-000", // g6
    "170-238-255":"000-000-000", // g8
    "170-255-255":"000-000-000", // g9

    // Block (Red = 204)

    // row 1 (2)
    "204-238-000":"000-000-000", // g8
    "204-255-000":"000-000-000", // g9

    // row 2 (2)
    "204-238-034":"000-000-000", // g8
    "204-255-034":"000-000-000", // g9

    // row 3 (2)
    "204-238-068":"000-000-000", // g8
    "204-255-068":"000-000-000", // g9

    // row 4 (1)
    "204-255-102":"000-000-000", // g9

    // row 5 (2)
    "204-238-136":"000-000-000", // g8
    "204-255-136":"000-000-000", // g9

    // row 6 (1)
    "204-255-170":"000-000-000", // g9

    // row 7 (5)
    "204-000-204":"000-000-000", // g1
    "204-034-204":"000-000-000", // g2
    "204-068-204":"000-000-000", // g3
    "204-102-204":"000-000-000", // g4
    "204-255-204":"000-000-000", // g9

    // row 8 (7)
    "204-000-238":"000-000-000", // g1
    "204-034-238":"000-000-000", // g2
    "204-068-238":"000-000-000", // g3
    "204-102-238":"000-000-000", // g4
    "204-136-238":"000-000-000", // g5
    "204-170-238":"000-000-000", // g6
    "204-255-238":"000-000-000", // g9

    // row 9 (8)
    "204-000-255":"000-000-000", // g1
    "204-034-255":"000-000-000", // g2
    "204-068-255":"000-000-000", // g3
    "204-102-255":"000-000-000", // g4
    "204-136-255":"000-000-000", // g5
    "204-170-255":"000-000-000", // g6
    "204-204-255":"000-000-000", // g7
    "204-255-255":"000-000-000", // g9

]
