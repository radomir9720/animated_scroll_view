abstract class ModificationState {
  const ModificationState();

  const factory ModificationState.initial() = _InitialModificationState;
  const factory ModificationState.insert() = _InsertItemState;
  const factory ModificationState.delete() = _DeleteItemState;
  const factory ModificationState.move() = _MoveItemState;

  R when<R>({
    required R Function() initial,
    required R Function() insert,
    required R Function() delete,
    required R Function() move,
  });
}

class _InitialModificationState extends ModificationState {
  const _InitialModificationState();

  @override
  R when<R>({
    required R Function() initial,
    required R Function() insert,
    required R Function() delete,
    required R Function() move,
  }) {
    return initial();
  }
}

class _InsertItemState extends ModificationState {
  const _InsertItemState();

  @override
  R when<R>({
    required R Function() initial,
    required R Function() insert,
    required R Function() delete,
    required R Function() move,
  }) {
    return insert();
  }
}

class _DeleteItemState extends ModificationState {
  const _DeleteItemState();

  @override
  R when<R>({
    required R Function() initial,
    required R Function() insert,
    required R Function() delete,
    required R Function() move,
  }) {
    return delete();
  }
}

class _MoveItemState extends ModificationState {
  const _MoveItemState();

  @override
  R when<R>({
    required R Function() initial,
    required R Function() insert,
    required R Function() delete,
    required R Function() move,
  }) {
    return move();
  }
}
