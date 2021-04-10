// react
import { ChangeEvent } from 'react'

// third-party
import classNames from 'classnames'
import { IRadioFilter, IRadioFilterValue } from '../../interfaces/filter'

export interface FilterCheckProps {
  data: IRadioFilter
  value: IRadioFilterValue
  onChangeValue?: (event: { filter: IRadioFilter; value: IRadioFilterValue }) => void
}

function FilterRadio(props: FilterCheckProps) {
  const { data, value, onChangeValue } = props

  const updateValue = (newValue: IRadioFilterValue) => {
    if (onChangeValue) {
      onChangeValue({ filter: data, value: newValue })
    }
  }

  const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.checked && event.target.value !== value) {
      updateValue(event.target.value)
    }
  }

  const itemsList = data.values.map(item => {
    let count

    if (item.count) {
      count = <span className="filter-list__counter">{item.count}</span>
    }

    const itemClasses = classNames('filter-list__item', {
      'filter-list__item--disabled': item.count === 0,
    })

    return (
      <label key={item.slug} className={itemClasses}>
        <span className="filter-list__input input-radio">
          <span className="input-radio__body">
            <input
              className="input-radio__input"
              type="radio"
              name={data.slug}
              value={item.slug}
              checked={value === item.slug}
              disabled={item.count === 0}
              onChange={handleChange}
            />
            <span className="input-radio__circle" />
          </span>
        </span>
        <span className="filter-list__title">{item.name}</span>
        {count}
      </label>
    )
  })

  return (
    <div className="filter-list">
      <div className="filter-list__list">{itemsList}</div>
    </div>
  )
}

export default FilterRadio
