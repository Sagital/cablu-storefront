// react
import { useCallback, useEffect, useMemo, useState } from 'react'

// third-party
import InputRange from 'react-input-range'

// application
import CurrencyFormat from '../shared/CurrencyFormat'
import { IRangeFilter, IRangeFilterValue } from '../../interfaces/filter'
// import { useDirection } from '../../store/locale/localeHooks';

function getFirstValidValue(...values: Array<number | null>): number | null {
  return values.reduce((acc, value) => (acc === null && (value || value === 0) ? value : acc), null)
}

interface FilterRangeProps {
  data: IRangeFilter
  value: IRangeFilterValue
  onChangeValue?: (event: { filter: IRangeFilter; value: IRangeFilterValue }) => void
}

function FilterRange(props: FilterRangeProps) {
  const { data, value, onChangeValue } = props
  const [propsFrom, propsTo] = value || []
  const [timer, setTimer] = useState<number>()
  const [state, setState] = useState([propsFrom, propsTo])
  const [stateFrom, stateTo] = state
  const direction = 'ltr'

  let { min, max } = data
  let from = Math.max(getFirstValidValue(stateFrom, propsFrom, min)!, min)
  let to = Math.min(getFirstValidValue(stateTo, propsTo, max)!, max)
  let fromLabel = from
  let toLabel = to

  // Update state from props.
  useEffect(() => {
    setState([propsFrom, propsTo])
  }, [propsFrom, propsTo])

  // Clear previous timer.
  useEffect(
    () => () => {
      clearTimeout(timer)
    },
    [timer]
  )

  const handleChange = useCallback(
    newValue => {
      let { min: newFrom, max: newTo } = newValue

        // This is needed to fix a bug in react-input-range.
      ;[newFrom, newTo] = [Math.max(newFrom, min), Math.min(newTo, max)]

      setState([newFrom, newTo])

      if (onChangeValue) {
        setTimer(
          (setTimeout(() => {
            onChangeValue({ filter: data, value: [newFrom, newTo] })
          }, 250) as unknown) as number
        )
      }
    },
    [min, max, data, onChangeValue, direction, setTimer, setState]
  )

  return useMemo(
    () => (
      <div className="filter-price">
        <div className="filter-price__slider" dir="ltr">
          <InputRange
            minValue={min}
            maxValue={max}
            value={{ min: from, max: to }}
            step={1}
            onChange={handleChange}
          />
        </div>
        <div className="filter-price__title">
          Price:{' '}
          <span className="filter-price__min-value">
            <CurrencyFormat value={fromLabel} />
          </span>
          {' – '}
          <span className="filter-price__max-value">
            <CurrencyFormat value={toLabel} />
          </span>
        </div>
      </div>
    ),
    [min, max, from, to, fromLabel, toLabel, handleChange]
  )
}

export default FilterRange
