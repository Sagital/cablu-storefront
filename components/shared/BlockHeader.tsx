// third-party
import classNames from 'classnames';

// application
import ArrowRoundedLeft7x11Svg from '../../svg/arrow-rounded-left-7x11.svg';
import ArrowRoundedRight7x11Svg from '../../svg/arrow-rounded-right-7x11.svg';

export interface BlockHeaderGroup {
    name: string;
    current: boolean;
}

export interface BlockHeaderProps<T extends BlockHeaderGroup> {
    title: string;
    arrows?: boolean;
    groups?: T[];
    onNext?: () => void;
    onPrev?: () => void;
    onGroupClick?: (group: T) => void;
}

function BlockHeader<T extends BlockHeaderGroup>(props: BlockHeaderProps<T>) {
    const {
        title,
        arrows,
        groups = [],
        onPrev,
        onNext,
        onGroupClick = () => {},
    } = props;

    let groupsList;

    if (groups.length > 0) {
        groupsList = groups.map((group, index) => {
            const classes = classNames('block-header__group', {
                'block-header__group--active': group.current,
            });

            return (
                <li key={index}>
                    <button type="button" className={classes} onClick={() => onGroupClick(group)}>
                        {group.name}
                    </button>
                </li>
            );
        });

        groupsList = (
            <ul className="block-header__groups-list">
                {groupsList}
            </ul>
        );
    }

    return (
        <div className="block-header">
            <h3 className="block-header__title">{title}</h3>
            <div className="block-header__divider" />
            {groupsList}
            {arrows && (
                <div className="block-header__arrows-list">
                    <button className="block-header__arrow block-header__arrow--left" type="button" onClick={onPrev}>
                        <ArrowRoundedLeft7x11Svg />
                    </button>
                    <button className="block-header__arrow block-header__arrow--right" type="button" onClick={onNext}>
                        <ArrowRoundedRight7x11Svg />
                    </button>
                </div>
            )}
        </div>
    );
}

export default BlockHeader;
