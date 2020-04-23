import 'dart:math' as math;

import 'main_player.dart';

//INITIALIZE
enum BlockType {
  I_SHAPE,
  L_SHAPE,
  L_SHAPE_IN,
  Z_SHAPE,
  Z_SHAPE_IN,
  H_SHAPE,
  T_SHAPE
}

const START = {
  BlockType.I_SHAPE: [3, 0],
  BlockType.L_SHAPE: [4, -1],
  BlockType.L_SHAPE_IN: [4, -1],
  BlockType.Z_SHAPE: [4, -1],
  BlockType.Z_SHAPE_IN: [4, -1],
  BlockType.H_SHAPE: [4, -1],
  BlockType.T_SHAPE: [4, -1],
};
const ORIGIN = {
  BlockType.I_SHAPE: [
    //could come in column on in row shape
    [1, -1],
    [-1, 1],
  ],
  BlockType.L_SHAPE: [
    //standard
    [0, 0]
  ],
  BlockType.L_SHAPE_IN: [
    //standard
    [0, 0]
  ],
  BlockType.Z_SHAPE: [
    //standard
    [0, 0]
  ],
  BlockType.Z_SHAPE_IN: [
    //standard
    [0, 0]
  ],
  BlockType.H_SHAPE: [
    //standard
    [0, 0]
  ],
  BlockType.T_SHAPE: [
    //could come in 4 different facings
    [0, 0],
    [0, 1],
    [1, -1],
    [-1, 0]
  ],
};
const THE_SHAPES_OF_THE_BLOCKS = {
  //shapes based on 1's in the array
  BlockType.I_SHAPE: [
    //--------------
    [1, 1, 1, 1]
  ],
  BlockType.L_SHAPE: [
    //        |
    //---------
    [0, 0, 1],
    [1, 1, 1],
  ],
  BlockType.L_SHAPE_IN: [
    // |
    // --------
    [1, 0, 0],
    [1, 1, 1],
  ],
  BlockType.Z_SHAPE: [
    //-------
    //       |
    //        ------
    [1, 1, 0],
    [0, 1, 1],
  ],
  BlockType.Z_SHAPE_IN: [
    //      -------
    //      |
    //------
    [0, 1, 1],
    [1, 1, 0],
  ],
  BlockType.H_SHAPE: [
    //    --
    //   |  |
    //    --
    [1, 1],
    [1, 1]
  ],
  BlockType.T_SHAPE: [
    //      |
    //      |
    //  ---------
    [0, 1, 0],
    [1, 1, 1]
  ]
};

class Block {
  final BlockType type;
  final List<List<int>> BlockShape;
  final List<int> pq;
  final int rotateIndex;

  Block(this.type, this.BlockShape, this.pq, this.rotateIndex);

  Block fall({int step = 1}) {
    return Block(type, BlockShape, [pq[0], pq[1] + step], rotateIndex);
  }

  Block right() {
    return Block(type, BlockShape, [pq[0] + 1, pq[1]], rotateIndex);
  }

  Block left() {
    return Block(type, BlockShape, [pq[0] - 1, pq[1]], rotateIndex);
  }

  Block rotate() {
    List<List<int>> result =
        List.filled(BlockShape[0].length, null, growable: false);
    for (int row = 0; row < BlockShape.length; row++) {
      for (int col = 0; col < BlockShape[row].length; col++) {
        if (result[col] == null) {
          result[col] = List.filled(BlockShape.length, 0, growable: false);
        }
        result[col][row] = BlockShape[BlockShape.length - 1 - row][col];
      }
    }
    final NEXT = [
      this.pq[0] + ORIGIN[type][rotateIndex][0],
      this.pq[1] + ORIGIN[type][rotateIndex][1]
    ];
    final nextRotateIndex =
        rotateIndex + 1 >= ORIGIN[this.type].length ? 0 : rotateIndex + 1;

    return Block(type, result, NEXT, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (pq[1] + BlockShape.length > GAME_PAD_HEIGHT ||
        pq[0] < 0 ||
        pq[0] + BlockShape[0].length > GAME_PAD_WIDTH) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  ///return null if do not show at [p][q]
  ///return 1 if show at [p,q]
  int get(int p, int q) {
    p -= pq[0];
    q -= pq[1];
    if (p < 0 || p >= BlockShape[0].length || q < 0 || q >= BlockShape.length) {
      return null;
    }
    return BlockShape[q][p] == 1 ? 1 : null;
  }

  static Block fromType(BlockType type) {
    final BlockShape = THE_SHAPES_OF_THE_BLOCKS[type];
    return Block(type, BlockShape, START[type], 0);
  }

  static Block getRandom() {
    final i = math.Random().nextInt(BlockType.values.length);
    return fromType(BlockType.values[i]);
  }
}
