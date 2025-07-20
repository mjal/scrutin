// This code makes no sense to me but it seems to works.
// It come from react-use-elmish (and was written in typescript)

type subAction<'action> =
  | DomainAction('action)
  | RemoveEffects

let makeTeaReducer = reducer => {
  ((state, effects), action) => {
    switch action {
    | RemoveEffects => (state, [])
    | DomainAction(action) => {
        let (nextState, nextEffects) = reducer(state, action)
        (nextState, effects->Belt.Array.concat(nextEffects))
      }
    }
  }
}

let useTea = (reducer: ('state, 'action) => ('state, 'effect), initialState: 'state) => {
  let teaReducer = React.useCallback1(makeTeaReducer(reducer), [reducer])

  let ((state, effects), dispatch) = React.useReducer(teaReducer, (initialState, []))

  let subDispatch = React.useCallback1(action => {
    dispatch(DomainAction(action))
  }, [dispatch])

  //React.useEffect(() => {
  if Belt.Array.length(effects) != 0 {
    dispatch(RemoveEffects)
    Belt.Array.forEach(effects, fx => {
      (async (fx) => {
        fx(action => dispatch(DomainAction(action)))
      })(fx)->ignore
    })
  }
  //  None
  //})//, [effects]);

  (state, subDispatch)
}
