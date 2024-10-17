import { mount } from '@vue/test-utils';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { nextTick, reactive } from 'vue';
import WorkingtimeChart from '../src/components/features/dashboard/WorkingChart.vue';
import { useWorkingtimesStore } from '../src/stores/workingtimes';
import Chart from 'chart.js/auto';

vi.mock('@/stores/workingtimes', () => ({
  useWorkingtimesStore: vi.fn()
}));

vi.mock('chart.js/auto', () => ({
  default: vi.fn()
}));

describe('WorkingtimeChart.vue', () => {
  let mockStore;

  beforeEach(() => {
    vi.clearAllMocks();

    mockStore = reactive({
      workingtimes: [],
      getWorkingtimes: vi.fn().mockResolvedValue([])
    });
    (useWorkingtimesStore as any).mockReturnValue(mockStore);

    (Chart as any).mockImplementation(() => ({
      destroy: vi.fn()
    }));

    document.getElementById = vi.fn().mockReturnValue(document.createElement('canvas'));
  });

  it('appelle getWorkingtimes au montage', async () => {
    mount(WorkingtimeChart);
    await nextTick();
    expect(mockStore.getWorkingtimes).toHaveBeenCalled();
  });

  it('crée un graphique avec les données correctes', async () => {
    const testData = [
      { start: '2023-01-01T09:00:00Z', end: '2023-01-01T17:00:00Z' },
      { start: '2023-01-02T08:30:00Z', end: '2023-01-02T16:30:00Z' }
    ];
    mockStore.workingtimes = testData;
    mockStore.getWorkingtimes.mockResolvedValue(testData);

    mount(WorkingtimeChart);
    await nextTick();
    await mockStore.getWorkingtimes();
    await nextTick();

    expect(Chart).toHaveBeenCalled();
    const chartCall = (Chart as any).mock.calls[0];
    expect(chartCall[1].data.labels).toHaveLength(2);
    expect(chartCall[1].data.datasets[0].data).toHaveLength(2);
  });

});