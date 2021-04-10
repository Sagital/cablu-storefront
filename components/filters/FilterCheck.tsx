// react
import { ChangeEvent, useState } from 'react'

// third-party
import classNames from 'classnames'

// application
import Check9x7Svg from '../../svg/check-9x7.svg'
import { ICheckFilter, ICheckFilterValue } from '../../interfaces/filter'
import { IFilter } from '../../types'

export interface FilterCheckProps {
  filter: IFilter
  values: string[]
  onChangeValue?: (event: { filter: IFilter; values: ICheckFilterValue }) => void
}

function FilterCheck(props: FilterCheckProps) {
  const { filter, values, onChangeValue } = props

  // noinspection DuplicatedCod
  const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
    const newValue = event.target.value

    let newValues = values

    if (event.target.checked && !values.includes(event.target.value)) {
      newValues = [...values, event.target.value]
    }
    if (!event.target.checked && values.includes(event.target.value)) {
      newValues = values.filter(x => x !== event.target.value)
    }

    if (onChangeValue) {
      onChangeValue({ filter: filter, values: newValues })
    }
  }

  const itemsList = filter.values.map(item => {
    let count

    if (item.count) {
      count = <span className="filter-list__counter">{item.count}</span>
    }

    const itemClasses = classNames('filter-list__item', {
      'filter-list__item--disabled': item.count === 0,
    })

    return (
      <label key={item.slug} className={itemClasses}>
        <span className="filter-list__input input-check">
          <span className="input-check__body">
            <input
              className="input-check__input"
              type="checkbox"
              value={item.slug}
              checked={values.includes(item.slug)}
              disabled={item.count === 0}
              onChange={handleChange}
            />
            <span className="input-check__box" />
            <Check9x7Svg className="input-check__icon" />
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

export default FilterCheck
