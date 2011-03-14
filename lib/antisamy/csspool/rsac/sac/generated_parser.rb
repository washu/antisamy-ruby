#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.6
# from Racc grammer file "".
#

require 'racc/parser.rb'

  require "antisamy/csspool/rsac/sac/conditions"
  require "antisamy/csspool/rsac/sac/selectors"

module RSAC
  class GeneratedParser < Racc::Parser

module_eval(<<'...end parser.y/module_eval...', 'parser.y', 307)
  include RSAC::Conditions
  include RSAC::Selectors
...end parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
   190,   -70,    70,   172,   173,    70,   149,   131,   124,     9,
   135,   136,   175,   137,    69,    10,   140,   141,   142,   143,
   144,   145,   146,   147,   -70,    57,    18,     9,    76,    58,
   -70,    77,   -70,    10,   174,   130,    59,   123,    70,   189,
   -70,   171,   149,   131,   114,     3,   135,   136,   113,   137,
     4,     5,   140,   141,   142,   143,   144,   145,   146,   147,
    42,    70,    62,    63,    64,   149,   131,   104,    42,   135,
   136,   130,   137,    34,    18,   140,   141,   142,   143,   144,
   145,   146,   147,   223,   222,    18,    42,    37,    23,    25,
    33,    34,    36,    18,   130,    37,   111,    18,    33,    35,
    36,    18,   108,    42,    18,   116,    23,    25,    34,    42,
    42,    76,   110,    37,    77,     3,    33,    35,    36,    42,
     4,     5,     9,    23,    25,     7,    18,    42,    10,   119,
    37,    18,    34,    33,    35,    36,    37,    37,     3,    33,
    33,    36,    36,     4,     5,    42,    37,    23,    25,    33,
    34,    36,    42,   121,    37,   122,    42,    33,    35,    36,
    99,    34,    42,   125,     3,    23,    25,    34,    42,     4,
     5,   126,    37,    34,    98,    33,    35,    36,    18,    37,
    42,    91,    33,    37,    36,    34,    33,    35,    36,    37,
    87,    87,    33,    35,    36,    37,    96,     3,    33,    35,
    36,   153,     4,     5,    18,    96,    92,    37,    96,    96,
    33,    35,    36,    18,    96,    92,    18,    18,    92,    92,
    96,     3,    18,     9,    92,  -120,     4,     5,    18,    10,
    92,    18,    18,    18,  -120,     3,    89,  -120,  -120,     3,
     4,     5,     3,  -120,     4,     5,   159,     4,     5,  -120,
   140,   141,   142,   143,   144,   145,   146,   147,    76,   110,
    18,    77,    76,   110,    87,    77,   162,    18,    18,    18,
   166,    18,    18,    59,    18,    18,    18,    18,    18,    18,
    18,    18,    18,    18,    18,    18,    18,    18,    66,    18,
   192,   193,    18,    18,    18,   197,    18,    87,   200,    18,
    18,    18,    47,    44,   206,    18,    18,    18,    18,    18,
   212,    18,    18,    18,    18,    18,   219,    16,     6,    18,
    18,    18,    18 ]

racc_action_check = [
   148,   132,   105,   129,   129,    37,   105,   105,    95,    45,
   105,   105,   132,   105,    37,    45,   105,   105,   105,   105,
   105,   105,   105,   105,   132,    29,   104,    46,    43,    29,
   132,    43,   132,    46,   132,   105,    29,    95,   164,   148,
   132,   129,   164,   164,    86,    11,   164,   164,    86,   164,
    11,    11,   164,   164,   164,   164,   164,   164,   164,   164,
    41,   176,    32,    32,    32,   176,   176,    67,   196,   176,
   176,   164,   176,   196,    70,   176,   176,   176,   176,   176,
   176,   176,   176,   207,   207,    75,     8,    41,   196,   196,
    41,     8,    41,    62,   176,   196,    81,    85,   196,   196,
   196,    59,    78,    49,    87,    88,     8,     8,    49,    40,
    39,    78,    78,     8,    78,    21,     8,     8,     8,    38,
    21,    21,     2,    49,    49,     2,    89,    50,     2,    90,
    49,    92,    50,    49,    49,    49,    40,    39,     5,    40,
    39,    40,    39,     5,     5,    51,    38,    50,    50,    38,
    51,    38,    30,    93,    50,    94,   100,    50,    50,    50,
    57,   100,   158,    96,    20,    51,    51,   158,    65,    20,
    20,    97,    51,    65,    56,    51,    51,    51,    63,    30,
   112,    54,    30,   100,    30,   112,   100,   100,   100,   158,
   106,   107,   158,   158,   158,    65,   117,     4,    65,    65,
    65,   108,     4,     4,   117,    55,   117,   112,   203,   167,
   112,   112,   112,    55,   165,    55,   203,   167,   203,   167,
   168,     3,   165,   156,   165,   117,     3,     3,   168,   156,
   168,   109,   110,   111,    55,    12,    53,   203,   167,    22,
    12,    12,     0,   165,    22,    22,   114,     0,     0,   168,
   133,   133,   133,   133,   133,   133,   133,   133,   155,   155,
   116,   155,   154,   154,    52,   154,   119,   121,   122,   123,
   124,   125,   126,   127,    47,    44,    36,   135,   136,   137,
   140,   141,   142,   143,   144,   145,   146,   147,    33,   149,
   150,   152,    28,    26,    25,   157,    24,   160,   161,    23,
    18,   166,    17,    10,   169,   170,   174,   175,     9,   189,
   190,   192,   193,     7,   197,   200,   201,     6,     1,   212,
   219,   222,   223 ]

racc_action_pointer = [
   233,   318,    97,   212,   188,   129,   317,   304,    80,   299,
   292,    36,   226,   nil,   nil,   nil,   nil,   292,   291,   nil,
   155,   106,   230,   290,   287,   285,   284,   nil,   283,    24,
   146,   nil,    55,   277,   nil,   nil,   267,     3,   113,   104,
   103,    54,   nil,    18,   266,   -16,     2,   265,   nil,    97,
   121,   139,   253,   231,   170,   204,   169,   155,   nil,    92,
   nil,   nil,    84,   169,   nil,   162,   nil,    56,   nil,   nil,
    65,   nil,   nil,   nil,   nil,    76,   nil,   nil,   101,   nil,
   nil,    66,   nil,   nil,   nil,    88,    43,    95,    93,   117,
    96,   nil,   122,   121,   122,     7,   133,   141,   nil,   nil,
   150,   nil,   nil,   nil,    17,     0,   179,   180,   192,   222,
   223,   224,   174,   nil,   241,   nil,   251,   195,   nil,   255,
   nil,   258,   259,   260,   240,   262,   263,   261,   nil,     0,
   nil,   nil,     0,   234,   nil,   268,   269,   270,   nil,   nil,
   271,   272,   273,   274,   275,   276,   277,   278,    -1,   280,
   260,   nil,   261,   nil,   252,   248,   198,   263,   156,   nil,
   286,   266,   nil,   nil,    36,   213,   292,   208,   219,   265,
   296,   nil,   nil,   nil,   297,   298,    59,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   300,
   270,   nil,   302,   303,   nil,   nil,    62,   305,   nil,   nil,
   306,   292,   nil,   207,   nil,   nil,   nil,    73,   nil,   nil,
   nil,   nil,   310,   nil,   nil,   nil,   nil,   nil,   nil,   311,
   nil,   nil,   312,   313,   nil,   nil,   nil,   nil ]

racc_action_default = [
  -118,  -121,   -15,  -115,  -116,  -117,  -121,  -120,    -9,  -120,
  -121,  -118,  -118,  -112,  -113,  -114,   228,  -121,  -120,    -2,
  -118,  -118,  -118,  -120,  -120,  -120,  -120,   -43,  -120,   -48,
   -90,   -50,   -52,  -121,   -54,   -55,  -120,  -121,   -95,   -96,
   -97,   -98,   -99,  -121,  -120,   -15,   -15,  -120,  -119,    -6,
    -7,    -8,  -121,  -121,   -27,   -65,  -121,  -121,   -46,  -120,
   -49,   -89,  -120,  -120,   -35,  -121,   -53,  -121,   -57,   -58,
  -120,   -91,   -92,   -93,   -94,  -120,  -106,  -107,  -121,   -13,
   -14,  -121,    -3,    -4,    -5,  -120,  -121,  -120,   -23,  -120,
   -29,   -26,  -120,  -121,  -121,   -63,  -121,  -121,   -44,   -45,
  -121,   -33,   -34,   -51,  -120,  -121,   -21,   -21,  -121,  -120,
  -120,  -120,   -42,   -17,  -121,   -19,  -120,   -65,   -25,  -121,
   -38,  -120,  -120,  -120,  -121,  -120,  -120,   -48,   -47,  -102,
   -36,   -37,   -32,  -121,   -72,  -120,  -120,  -120,   -76,   -77,
  -120,  -120,  -120,  -120,  -120,  -120,  -120,  -120,  -121,  -120,
  -121,   -20,  -121,   -12,  -111,  -110,   -15,  -121,   -41,   -18,
  -121,  -121,   -28,   -39,  -121,   -65,  -120,   -65,   -65,  -121,
  -120,  -103,  -104,  -105,  -120,  -120,  -121,   -71,   -73,   -74,
   -75,   -78,   -79,   -80,   -81,   -82,   -83,   -84,   -85,  -120,
  -121,   -88,  -120,  -120,  -108,  -109,    -9,  -120,   -40,   -22,
  -120,   -68,   -60,   -65,   -62,   -64,   -56,  -121,   -30,   -31,
   -69,   -86,  -120,   -10,   -11,    -1,   -16,   -24,   -59,  -120,
   -67,   -61,  -120,  -120,   -87,   -66,  -100,  -101 ]

racc_goto_table = [
    17,    19,    43,     8,    86,   148,   118,   107,   157,    90,
    93,    48,   158,    85,    61,   176,    52,    53,    54,    55,
    65,    56,    71,    72,    73,    74,   150,   152,   127,    67,
   103,   128,    60,    75,   169,    68,     1,    78,   218,   220,
    81,   177,    82,    83,    84,   170,    79,    80,   nil,   nil,
   nil,   nil,   100,   nil,   198,   101,   102,   nil,   158,   nil,
   nil,   nil,   nil,   105,   201,   nil,   nil,   nil,   106,   nil,
   nil,   nil,   161,   nil,   nil,   nil,   210,   nil,   112,   nil,
   115,   nil,   117,   194,   195,   120,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   129,   nil,   nil,
   nil,   nil,   154,   155,   156,   nil,   nil,   nil,   nil,   160,
   nil,   nil,   199,   nil,   163,   164,   165,   nil,   167,   168,
   202,   nil,   204,   205,   nil,   nil,   nil,   nil,   178,   179,
   180,   nil,   nil,   181,   182,   183,   184,   185,   186,   187,
   188,   nil,   191,   nil,     2,   nil,   nil,    13,    14,    15,
   nil,   nil,   nil,   nil,   nil,    45,    46,   196,   221,   203,
   nil,   nil,   nil,   207,    49,    50,    51,   208,   209,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   211,   nil,   nil,   213,   214,   nil,   nil,   215,
   216,   nil,   nil,   217,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   224,   nil,   nil,   nil,   nil,
   nil,   nil,   225,   nil,   nil,   226,   227 ]

racc_goto_check = [
     3,     5,     3,     4,    16,    40,    21,    13,    15,    20,
    19,     3,     6,    14,    33,    22,     3,     3,     3,     3,
    23,     3,    33,    33,    33,    33,    11,    11,    27,     3,
    28,    29,    32,    10,    36,    38,     1,     3,    41,    42,
     3,    44,     5,     5,     5,    47,     4,     4,   nil,   nil,
   nil,   nil,     3,   nil,    15,     3,     3,   nil,     6,   nil,
   nil,   nil,   nil,     3,    40,   nil,   nil,   nil,     3,   nil,
   nil,   nil,    19,   nil,   nil,   nil,    40,   nil,     3,   nil,
     3,   nil,     3,    13,    13,     3,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     3,   nil,   nil,
   nil,   nil,     3,     3,     3,   nil,   nil,   nil,   nil,     3,
   nil,   nil,    16,   nil,     3,     3,     3,   nil,     3,     3,
    19,   nil,    19,    19,   nil,   nil,   nil,   nil,     3,     3,
     3,   nil,   nil,     3,     3,     3,     3,     3,     3,     3,
     3,   nil,     3,   nil,     2,   nil,   nil,     2,     2,     2,
   nil,   nil,   nil,   nil,   nil,     2,     2,     4,    19,     3,
   nil,   nil,   nil,     3,     2,     2,     2,     3,     3,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,     3,   nil,   nil,     3,     3,   nil,   nil,     5,
     3,   nil,   nil,     3,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     3,   nil,   nil,   nil,   nil,
   nil,   nil,     3,   nil,   nil,     3,     3 ]

racc_goto_pointer = [
   nil,    36,   144,    -7,     1,    -7,  -100,   nil,   nil,   nil,
   -10,   -80,   nil,   -71,   -39,  -104,   -48,   nil,   nil,   -45,
   -45,   -84,  -117,   -12,   nil,   nil,   nil,   -72,   -35,   -69,
   nil,   nil,     2,   -16,   nil,   nil,   -95,   nil,    -2,   nil,
  -100,  -163,  -162,   nil,   -92,   nil,   nil,   -84 ]

racc_goto_default = [
   nil,   nil,   nil,    97,   nil,   nil,    20,    21,    22,    11,
   109,   nil,    12,   nil,   nil,   nil,   151,    88,    24,   nil,
   nil,   nil,   nil,   nil,   133,    94,    26,    29,    27,    28,
    32,    30,   nil,    31,    39,    40,   nil,    41,   139,    95,
   nil,   nil,   nil,   132,   134,   138,    38,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  9, 43, :_reduce_none,
  3, 43, :_reduce_none,
  3, 47, :_reduce_none,
  3, 47, :_reduce_none,
  3, 47, :_reduce_none,
  2, 47, :_reduce_none,
  2, 47, :_reduce_none,
  2, 47, :_reduce_none,
  0, 47, :_reduce_none,
  7, 51, :_reduce_10,
  7, 54, :_reduce_11,
  5, 54, :_reduce_12,
  3, 46, :_reduce_none,
  3, 46, :_reduce_none,
  0, 46, :_reduce_none,
  7, 49, :_reduce_16,
  2, 56, :_reduce_17,
  3, 56, :_reduce_18,
  2, 59, :_reduce_none,
  1, 53, :_reduce_none,
  0, 53, :_reduce_none,
  4, 58, :_reduce_22,
  1, 58, :_reduce_23,
  7, 50, :_reduce_24,
  4, 60, :_reduce_25,
  1, 62, :_reduce_none,
  0, 62, :_reduce_none,
  2, 63, :_reduce_28,
  0, 63, :_reduce_none,
  2, 64, :_reduce_none,
  2, 64, :_reduce_none,
  0, 64, :_reduce_none,
  2, 65, :_reduce_33,
  2, 65, :_reduce_34,
  1, 65, :_reduce_35,
  1, 66, :_reduce_none,
  1, 66, :_reduce_none,
  2, 67, :_reduce_none,
  5, 48, :_reduce_39,
  2, 57, :_reduce_none,
  1, 57, :_reduce_none,
  0, 57, :_reduce_none,
  1, 69, :_reduce_43,
  3, 68, :_reduce_44,
  3, 68, :_reduce_45,
  2, 68, :_reduce_46,
  4, 71, :_reduce_47,
  1, 71, :_reduce_none,
  2, 72, :_reduce_49,
  1, 72, :_reduce_50,
  3, 70, :_reduce_51,
  1, 70, :_reduce_none,
  2, 76, :_reduce_53,
  1, 73, :_reduce_54,
  1, 73, :_reduce_55,
  6, 77, :_reduce_56,
  2, 79, :_reduce_57,
  2, 79, :_reduce_58,
  5, 81, :_reduce_59,
  4, 61, :_reduce_none,
  5, 61, :_reduce_61,
  4, 61, :_reduce_62,
  1, 61, :_reduce_none,
  4, 61, :_reduce_none,
  0, 61, :_reduce_none,
  2, 84, :_reduce_none,
  1, 83, :_reduce_none,
  0, 83, :_reduce_none,
  3, 82, :_reduce_69,
  1, 82, :_reduce_none,
  2, 85, :_reduce_71,
  1, 85, :_reduce_72,
  2, 85, :_reduce_none,
  2, 85, :_reduce_none,
  2, 85, :_reduce_none,
  1, 85, :_reduce_none,
  1, 85, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  2, 86, :_reduce_none,
  5, 80, :_reduce_86,
  6, 80, :_reduce_87,
  2, 87, :_reduce_none,
  1, 74, :_reduce_none,
  0, 74, :_reduce_none,
  2, 75, :_reduce_91,
  2, 75, :_reduce_92,
  2, 75, :_reduce_93,
  2, 75, :_reduce_94,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 75, :_reduce_none,
  1, 88, :_reduce_99,
  4, 78, :_reduce_100,
  4, 78, :_reduce_101,
  0, 78, :_reduce_none,
  1, 89, :_reduce_none,
  1, 89, :_reduce_none,
  1, 89, :_reduce_none,
  1, 52, :_reduce_none,
  1, 52, :_reduce_none,
  3, 55, :_reduce_none,
  3, 55, :_reduce_none,
  2, 55, :_reduce_none,
  2, 55, :_reduce_none,
  2, 44, :_reduce_none,
  2, 44, :_reduce_none,
  2, 44, :_reduce_none,
  1, 44, :_reduce_none,
  1, 44, :_reduce_none,
  1, 44, :_reduce_none,
  0, 44, :_reduce_none,
  2, 45, :_reduce_none,
  0, 45, :_reduce_none ]

racc_reduce_n = 121

racc_shift_n = 228

racc_token_table = {
  false => 0,
  :error => 1,
  :FUNCTION => 2,
  :INCLUDES => 3,
  :DASHMATCH => 4,
  :LBRACE => 5,
  :HASH => 6,
  :PLUS => 7,
  :GREATER => 8,
  :S => 9,
  :STRING => 10,
  :IDENT => 11,
  :COMMA => 12,
  :URI => 13,
  :CDO => 14,
  :CDC => 15,
  :NUMBER => 16,
  :PERCENTAGE => 17,
  :LENGTH => 18,
  :EMS => 19,
  :EXS => 20,
  :ANGLE => 21,
  :TIME => 22,
  :FREQ => 23,
  :IMPORTANT_SYM => 24,
  :IMPORT_SYM => 25,
  :MEDIA_SYM => 26,
  :PAGE_SYM => 27,
  :CHARSET_SYM => 28,
  :DIMENSION => 29,
  ";" => 30,
  "@" => 31,
  "}" => 32,
  ":" => 33,
  "/" => 34,
  "-" => 35,
  "." => 36,
  "*" => 37,
  "[" => 38,
  "]" => 39,
  ")" => 40,
  "=" => 41 }

racc_nt_base = 42

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "FUNCTION",
  "INCLUDES",
  "DASHMATCH",
  "LBRACE",
  "HASH",
  "PLUS",
  "GREATER",
  "S",
  "STRING",
  "IDENT",
  "COMMA",
  "URI",
  "CDO",
  "CDC",
  "NUMBER",
  "PERCENTAGE",
  "LENGTH",
  "EMS",
  "EXS",
  "ANGLE",
  "TIME",
  "FREQ",
  "IMPORTANT_SYM",
  "IMPORT_SYM",
  "MEDIA_SYM",
  "PAGE_SYM",
  "CHARSET_SYM",
  "DIMENSION",
  "\";\"",
  "\"@\"",
  "\"}\"",
  "\":\"",
  "\"/\"",
  "\"-\"",
  "\".\"",
  "\"*\"",
  "\"[\"",
  "\"]\"",
  "\")\"",
  "\"=\"",
  "$start",
  "stylesheet",
  "s_cdo_cdc_0toN",
  "s_0toN",
  "import_0toN",
  "ruleset_media_page_0toN",
  "ruleset",
  "media",
  "page",
  "import",
  "string_or_uri",
  "medium_0toN",
  "ignorable_at",
  "string_uri_or_ident_1toN",
  "medium_rollup",
  "ruleset_0toN",
  "medium_1toN",
  "medium",
  "page_start",
  "declaration_0toN",
  "optional_page",
  "optional_pseudo_page",
  "operator",
  "combinator",
  "unary_operator",
  "property",
  "selector_1toN",
  "selector",
  "simple_selector_1toN",
  "selector_list",
  "simple_selector",
  "element_name",
  "hcap_0toN",
  "hcap_1toN",
  "class",
  "attrib",
  "attrib_val_0or1",
  "pseudo",
  "function",
  "declaration",
  "expr",
  "prio_0or1",
  "prio",
  "term",
  "num_or_length",
  "hexcolor",
  "attribute_id",
  "eql_incl_dash" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

# reduce 4 omitted

# reduce 5 omitted

# reduce 6 omitted

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

module_eval(<<'.,.,', 'parser.y', 22)
  def _reduce_10(val, _values, result)
            self.document_handler.import_style(val[2], val[4] || [])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 27)
  def _reduce_11(val, _values, result)
            self.document_handler.ignorable_at_rule(val[1])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 30)
  def _reduce_12(val, _values, result)
            yyerrok
        self.document_handler.ignorable_at_rule(val[1])
      
    result
  end
.,.,

# reduce 13 omitted

# reduce 14 omitted

# reduce 15 omitted

module_eval(<<'.,.,', 'parser.y', 41)
  def _reduce_16(val, _values, result)
            self.document_handler.end_media(val[2])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 45)
  def _reduce_17(val, _values, result)
     self.document_handler.start_media(val.first) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 47)
  def _reduce_18(val, _values, result)
            yyerrok
        self.document_handler.start_media(val.first)
        error = ParseException.new("Error near: \"#{val[0]}\"")
        self.error_handler.error(error)
      
    result
  end
.,.,

# reduce 19 omitted

# reduce 20 omitted

# reduce 21 omitted

module_eval(<<'.,.,', 'parser.y', 61)
  def _reduce_22(val, _values, result)
     result = [val.first, val.last].flatten 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 62)
  def _reduce_23(val, _values, result)
     result = [val.first] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 66)
  def _reduce_24(val, _values, result)
            page_stuff = val.first
        self.document_handler.end_page(page_stuff[0], page_stuff[1])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 72)
  def _reduce_25(val, _values, result)
            result = [val[2], val[3]]
        self.document_handler.start_page(val[2], val[3])
      
    result
  end
.,.,

# reduce 26 omitted

# reduce 27 omitted

module_eval(<<'.,.,', 'parser.y', 81)
  def _reduce_28(val, _values, result)
     result = val[1] 
    result
  end
.,.,

# reduce 29 omitted

# reduce 30 omitted

# reduce 31 omitted

# reduce 32 omitted

module_eval(<<'.,.,', 'parser.y', 90)
  def _reduce_33(val, _values, result)
     result = :SAC_DIRECT_ADJACENT_SELECTOR 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 91)
  def _reduce_34(val, _values, result)
     result = :SAC_CHILD_SELECTOR 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 92)
  def _reduce_35(val, _values, result)
     result = :SAC_DESCENDANT_SELECTOR 
    result
  end
.,.,

# reduce 36 omitted

# reduce 37 omitted

# reduce 38 omitted

module_eval(<<'.,.,', 'parser.y', 102)
  def _reduce_39(val, _values, result)
            self.document_handler.end_selector([val.first].flatten.compact)
      
    result
  end
.,.,

# reduce 40 omitted

# reduce 41 omitted

# reduce 42 omitted

module_eval(<<'.,.,', 'parser.y', 111)
  def _reduce_43(val, _values, result)
     result = val.flatten 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 115)
  def _reduce_44(val, _values, result)
            self.document_handler.start_selector([val.first].flatten.compact)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 118)
  def _reduce_45(val, _values, result)
            yyerrok
        self.document_handler.start_selector([val.first].flatten.compact)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 122)
  def _reduce_46(val, _values, result)
            self.document_handler.start_selector([val.first].flatten.compact)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 126)
  def _reduce_47(val, _values, result)
     result = [val[0], val[3]] 
    result
  end
.,.,

# reduce 48 omitted

module_eval(<<'.,.,', 'parser.y', 131)
  def _reduce_49(val, _values, result)
            result =  if val[1].nil?
                    val.first
                  else
                    ConditionalSelector.new(val.first, val[1])
                  end
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 138)
  def _reduce_50(val, _values, result)
            result = ConditionalSelector.new(nil, val.first)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 143)
  def _reduce_51(val, _values, result)
            result =
          case val[1]
          when :SAC_DIRECT_ADJACENT_SELECTOR
            SiblingSelector.new(val.first, val[2])
          when :SAC_DESCENDANT_SELECTOR
            DescendantSelector.new(val.first, val[2])
          when :SAC_CHILD_SELECTOR
            ChildSelector.new(val.first, val[2])
          end
      
    result
  end
.,.,

# reduce 52 omitted

module_eval(<<'.,.,', 'parser.y', 156)
  def _reduce_53(val, _values, result)
     result = ClassCondition.new(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 159)
  def _reduce_54(val, _values, result)
     result = ElementSelector.new(val.first) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 160)
  def _reduce_55(val, _values, result)
     result = SimpleSelector.new() 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 164)
  def _reduce_56(val, _values, result)
            result = AttributeCondition.build(val[2], val[4])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 169)
  def _reduce_57(val, _values, result)
            result = PseudoClassCondition.new(val[1])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 171)
  def _reduce_58(val, _values, result)
     result = PseudoClassCondition.new(val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 175)
  def _reduce_59(val, _values, result)
            if value = self.property_parser.parse_tokens(
          self.tokenizer.tokenize(val.flatten[0..-2].join(' '))
        )

          value = [value].flatten

          self.document_handler.property(val.first, value, !val[4].nil?)
          result = value
        end
      
    result
  end
.,.,

# reduce 60 omitted

module_eval(<<'.,.,', 'parser.y', 189)
  def _reduce_61(val, _values, result)
            yyerrok
        error = ParseException.new("Unkown property: \"#{val[1]}\"")
        self.error_handler.error(error)
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 194)
  def _reduce_62(val, _values, result)
            yyerrok
        error = ParseException.new("Unkown property: \"#{val[0]}\"")
        self.error_handler.error(error)
      
    result
  end
.,.,

# reduce 63 omitted

# reduce 64 omitted

# reduce 65 omitted

# reduce 66 omitted

# reduce 67 omitted

# reduce 68 omitted

module_eval(<<'.,.,', 'parser.y', 210)
  def _reduce_69(val, _values, result)
     result = val 
    result
  end
.,.,

# reduce 70 omitted

module_eval(<<'.,.,', 'parser.y', 214)
  def _reduce_71(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 215)
  def _reduce_72(val, _values, result)
     result = val 
    result
  end
.,.,

# reduce 73 omitted

# reduce 74 omitted

# reduce 75 omitted

# reduce 76 omitted

# reduce 77 omitted

# reduce 78 omitted

# reduce 79 omitted

# reduce 80 omitted

# reduce 81 omitted

# reduce 82 omitted

# reduce 83 omitted

# reduce 84 omitted

# reduce 85 omitted

module_eval(<<'.,.,', 'parser.y', 234)
  def _reduce_86(val, _values, result)
            result = Function.new(val[0], val[2].flatten.select { |x| x !~ /,/ })
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 236)
  def _reduce_87(val, _values, result)
     yyerrok; result = [val[0], val[2], val[3]] 
    result
  end
.,.,

# reduce 88 omitted

# reduce 89 omitted

# reduce 90 omitted

module_eval(<<'.,.,', 'parser.y', 247)
  def _reduce_91(val, _values, result)
            result = CombinatorCondition.new(val[0], val[1])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 250)
  def _reduce_92(val, _values, result)
            result = CombinatorCondition.new(val[0], val[1])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 253)
  def _reduce_93(val, _values, result)
            result = CombinatorCondition.new(val[0], val[1])
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 256)
  def _reduce_94(val, _values, result)
            result = CombinatorCondition.new(val[0], val[1])
      
    result
  end
.,.,

# reduce 95 omitted

# reduce 96 omitted

# reduce 97 omitted

# reduce 98 omitted

module_eval(<<'.,.,', 'parser.y', 264)
  def _reduce_99(val, _values, result)
     result = IDCondition.new(val.first) 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 267)
  def _reduce_100(val, _values, result)
     result = [val.first, val[2]] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.y', 268)
  def _reduce_101(val, _values, result)
     result = [val.first, val[2]] 
    result
  end
.,.,

# reduce 102 omitted

# reduce 103 omitted

# reduce 104 omitted

# reduce 105 omitted

# reduce 106 omitted

# reduce 107 omitted

# reduce 108 omitted

# reduce 109 omitted

# reduce 110 omitted

# reduce 111 omitted

# reduce 112 omitted

# reduce 113 omitted

# reduce 114 omitted

# reduce 115 omitted

# reduce 116 omitted

# reduce 117 omitted

# reduce 118 omitted

# reduce 119 omitted

# reduce 120 omitted

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class GeneratedParser
  end   # module RSAC