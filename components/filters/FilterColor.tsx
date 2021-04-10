// // react
// import { ChangeEvent } from 'react';
//
// // third-party
// import classNames from 'classnames';
//
// // application
// import Check12x9Svg from '../../svg/check-12x9.svg';
// import { colorType } from '../../services/color';
// import { IColorFilter, IColorFilterValue } from '../../interfaces/filter';
//
// export interface FilterCheckProps {
//     data: IColorFilter;
//     value: IColorFilterValue;
//     onChangeValue?: (event: { filter: IColorFilter, value: IColorFilterValue }) => void;
// }
//
// function FilterColor(props: FilterCheckProps) {
//     const { data, value, onChangeValue } = props;
//
//     const updateValue = (newValue: IColorFilterValue) => {
//         if (onChangeValue) {
//             onChangeValue({ filter: data, value: newValue });
//         }
//     };
//
//     // noinspection DuplicatedCode
//     const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
//         if (event.target.checked && !value.includes(event.target.value)) {
//             updateValue([...value, event.target.value]);
//         }
//         if (!event.target.checked && value.includes(event.target.value)) {
//             updateValue(value.filter((x) => x !== event.target.value));
//         }
//     };
//
//     const itemsList = data.items.map((item) => (
//         <div key={item.slug} className="filter-color__item">
//             <span
//                 className={classNames('filter-color__check input-check-color', {
//                     'input-check-color--white': colorType(item.color) === 'white',
//                     'input-check-color--light': colorType(item.color) === 'light',
//                 })}
//                 style={{ color: item.color }}
//             >
//                 <label className="input-check-color__body">
//                     <input
//                         className="input-check-color__input"
//                         type="checkbox"
//                         value={item.slug}
//                         checked={value.includes(item.slug)}
//                         disabled={item.count === 0}
//                         onChange={handleChange}
//                     />
//                     <span className="input-check-color__box" />
//                     <Check12x9Svg className="input-check-color__icon" />
//                     <span className="input-check-color__stick" />
//                 </label>
//             </span>
//         </div>
//     ));
//
//     return (
//         <div className="filter-color">
//             <div className="filter-color__list">
//                 {itemsList}
//             </div>
//         </div>
//     );
// }
//
// export default FilterColor;

export {}
