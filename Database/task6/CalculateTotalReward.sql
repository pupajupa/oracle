CREATE OR REPLACE FUNCTION calculate_total_reward(
    p_monthly_salary IN NUMBER,
    p_bonus_percent IN NUMBER
) RETURN NUMBER
IS
    v_total_reward NUMBER;
BEGIN
    -- Проверка на корректность введенных данных
    IF p_monthly_salary IS NULL OR p_monthly_salary <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Некорректное значение месячной зарплаты. Зарплата должна быть положительным числом.');
    END IF;

    IF p_bonus_percent IS NULL OR p_bonus_percent < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Некорректное значение процента премиальных. Процент должен быть неотрицательным числом.');
    END IF;

    -- Преобразование процента премиальных в дробное число
    v_total_reward := (1 + p_bonus_percent / 100) * 12 * p_monthly_salary;

    RETURN v_total_reward;
EXCEPTION
    WHEN OTHERS THEN
        -- Обработка других возможных ошибок
        RAISE_APPLICATION_ERROR(-20003, 'Произошла ошибка при вычислении общего вознаграждения: ' || SQLERRM);
END;