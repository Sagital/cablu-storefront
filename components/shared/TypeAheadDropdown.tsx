import React from 'react'
import Downshift from 'downshift'
import { matchSorter } from 'match-sorter'
import classNames from 'classnames'

export default function TypeAheadDropDown(props: any) {
  const items = props.items

  function getItems(filter: string | null): { value: string; name: string }[] {
    return filter
      ? matchSorter(items, filter, {
          keys: ['value'],
          keepDiacritics: true,
        })
      : items
  }

  function getItemName(value: string) {
    return items.find((i: { value: string; name: string }) => i.value === value)?.name || ''
  }

  return (
    <Downshift
      itemToString={item => (item ? item.value : '')}
      onInputValueChange={value => {
        console.log(value)
      }}
    >
      {({
        getInputProps,
        getItemProps,
        clearSelection,
        getToggleButtonProps,
        getMenuProps,
        isOpen,
        inputValue,
        clearItems,
        closeMenu,
        getRootProps,
      }) => {
        return (
          <div
            className={classNames([
              isOpen ? 'typeahead__container--open' : 'typeahead__container',
              props.error ? 'is-invalid' : '',
            ])}
            {...getRootProps()}
          >
            <button {...getToggleButtonProps()} className="form-control typeahead__button">
              {getItemName(props.value) || props.placeholder}
            </button>

            <div
              {...getMenuProps()}
              className={isOpen ? 'typeahead__menu' : 'typeahead__menu hidden'}
            >
              <input {...getInputProps()} className="typeahead__search" />

              <ul className="typeahead">
                {getItems(inputValue).map((item, index) => (
                  <li
                    className="typeahead"
                    {...getItemProps({
                      onClick: () => {
                        props.setValue(item.value)
                        closeMenu()
                        clearSelection()
                        clearItems()
                      },
                      key: item.value,
                      index,
                      item,
                    })}
                  >
                    {item.name}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        )
      }}
    </Downshift>
  )
}
