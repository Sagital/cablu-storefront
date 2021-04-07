// react
import { createRef, Component, TransitionEvent } from 'react';

// application
import ArrowRoundedDown9x6Svg from '../../svg/arrow-rounded-down-9x6.svg';
import departmentsService from '../../services/departmentsService';
import DepartmentsLinks from './DepartmentsLinks';
import Menu18x14Svg from '../../svg/menu-18x14.svg';

export interface DepartmentsState {
    open: boolean;
    fixed: boolean;
    area: HTMLElement | null;
}

class Departments extends Component<{}, DepartmentsState> {
    rootRef = createRef<HTMLDivElement>();

    contentRef = createRef<HTMLDivElement>();

    constructor(props: {}) {
        super(props);

        this.state = {
            open: false,
            fixed: false,
            area: null,
        };
    }

    componentDidMount() {
        document.addEventListener('mousedown', this.handleOutsideClick);

        this.unsubscribeAria = departmentsService.subscribe((area) => {
            this.setState({
                fixed: !!area,
                area,
            });
        });

        this.setState({
            fixed: !!departmentsService.area,
            area: departmentsService.area,
        });
    }

    componentDidUpdate(prevProps: DepartmentsState, prevState: DepartmentsState) {
        const { fixed, area, open } = this.state;

        if (!this.rootRef.current || !this.contentRef.current) {
            return;
        }

        const root = this.rootRef.current;
        const content = this.contentRef.current;

        if (prevState.fixed !== fixed) {
            if (fixed && area) {
                const areaRect = area.getBoundingClientRect();
                const areaBottom = areaRect.top + areaRect.height + window.scrollY;

                root.classList.remove('departments--transition');
                root.classList.add('departments--fixed', 'departments--opened');

                const height = areaBottom - (content.getBoundingClientRect().top + window.scrollY);

                content.style.height = `${height}px`;
                content.getBoundingClientRect(); // force reflow
            } else {
                root.classList.remove('departments--opened', 'departments--fixed');
                content.style.height = '';
            }
        } else if (!fixed) {
            if (open) {
                content.getBoundingClientRect(); // force reflow
                const startHeight = content.getBoundingClientRect().height;

                root.classList.add('departments--transition', 'departments--opened');

                const endHeight = content.getBoundingClientRect().height;

                content.style.height = `${startHeight}px`;
                content.getBoundingClientRect(); // force reflow
                content.style.height = `${endHeight}px`;
            } else {
                const startHeight = content.getBoundingClientRect().height;

                content.style.height = `${startHeight}px`;

                root.classList.add('departments--transition');
                root.classList.remove('departments--opened');

                content.getBoundingClientRect(); // force reflow
                content.style.height = '';
            }
        }
    }

    componentWillUnmount() {
        document.removeEventListener('mousedown', this.handleOutsideClick);

        this.unsubscribeAria();
    }

    unsubscribeAria = () => {};

    handleOutsideClick = (event: MouseEvent) => {
        const { open } = this.state;

        if (open && this.rootRef.current && !this.rootRef.current.contains(event.target as HTMLElement)) {
            this.setState(() => ({
                open: false,
            }));
        }
    };

    handleButtonClick = () => {
        this.setState((state) => ({
            open: !state.open,
        }));
    };

    handleTransitionEnd = (event: TransitionEvent) => {
        if (this.rootRef.current && this.contentRef.current && event.propertyName === 'height') {
            this.rootRef.current.classList.remove('departments--transition');
            this.contentRef.current.style.height = '';
        }
    };

    render() {
        return (
            <div className="departments" ref={this.rootRef}>
                <div className="departments__body">
                    <div
                        ref={this.contentRef}
                        className="departments__links-wrapper"
                        onTransitionEnd={this.handleTransitionEnd}
                    >
                        <DepartmentsLinks />
                    </div>
                </div>

                <button type="button" className="departments__button" onClick={this.handleButtonClick}>
                    <Menu18x14Svg className="departments__button-icon" />
                    Shop By Category
                    <ArrowRoundedDown9x6Svg className="departments__button-arrow" />
                </button>
            </div>
        );
    }
}

export default Departments;
