package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import com.dat3m.dartagnan.program.event.metadata.MetadataMap;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;

public abstract class AbstractEvent implements Event {

	protected Thread thread; // The thread this event belongs to
	// This id is dynamically changing during processing.
	protected transient int globalId = -1; // (Global) ID within a program

	protected final MetadataMap metadataMap = new MetadataMap();
	protected final Set<String> tags;

	private transient AbstractEvent successor;
	private transient AbstractEvent predecessor;

	protected AbstractEvent(){
		tags = new HashSet<>();
	}

	protected AbstractEvent(AbstractEvent other){
		copyAllMetadataFrom(other);
        this.tags = other.tags; // TODO: Dangerous code! A Copy-on-Write Set should be used (e.g. PersistentSet/Map)
        this.thread = other.thread;
    }

	@Override
	public int getGlobalId() { return globalId; }
	@Override
	public void setGlobalId(int id) { this.globalId = id; }

	// ============================================ Metadata ============================================

	@Override
	public void copyAllMetadataFrom(Event other) {
		((AbstractEvent)other).metadataMap.getAllMetadata().forEach(this.metadataMap::put);
	}

	@Override
	public void copyMetadataFrom(Event other, Class<? extends Metadata> metadataClass) {
		other.setMetadata(other.getMetadata(metadataClass));
	}

	@Override
	public boolean hasMetadata(Class<? extends Metadata> metadataClass) { return metadataMap.contains(metadataClass); }
	@Override
	public <T extends Metadata> T getMetadata(Class<T> metadataClass) { return metadataMap.get(metadataClass); }
	@Override
	public <T extends Metadata> T setMetadata(T metadata) { return metadataMap.put(metadata); }

	@Override
	public boolean hasEqualMetadata(Event other, Class<? extends Metadata> metadataClass) {
		return Objects.equals(getMetadata(metadataClass), other.getMetadata(metadataClass));
	}

	// TODO: Remove this
	@Override
	public Event setCFileInformation(int line, String sourceCodeFilePath) {
		setMetadata(new SourceLocation(sourceCodeFilePath, line));
		return this;
	}

	// ===============================================================================================

	// ============================================ Tags =============================================

	// The set of tags should not be modified directly.
	@Override
	public Set<String> getTags() { return tags; }
	@Override
	public boolean hasTag(String tag){ return tag != null && tags.contains(tag); }

	@Override
	public void addTags(Collection<? extends String> tags) { this.tags.addAll(tags); }
	@Override
	public void addTags(String... tags){ addTags(Arrays.asList(tags)); }
	@Override
	public void removeTags(Collection<? extends String> tags) { this.tags.removeAll(tags); }
	@Override
	public void removeTags(String... tags){  removeTags(Arrays.asList(tags)); }

	// ===============================================================================================

	// ======================================== Control-flow =========================================

	@Override
	public Event getSuccessor() { return successor; }
	@Override
	public Event getPredecessor() { return predecessor; }

	@Override
	public Thread getThread() { return thread; }
	@Override
	public void setThread(Thread thread) {
		this.thread = Preconditions.checkNotNull(thread);
	}

	@Override
	public void setSuccessor(Event ev) {
		final AbstractEvent event = (AbstractEvent)ev;
		if (successor != null) {
			successor.predecessor = null;
		}
		if (event != null) {
			if (event.predecessor != null){
				event.predecessor.successor = null;
			}
			event.predecessor = this;
			event.setThread(this.thread);
		}
		successor = event;
	}

	@Override
	public void setPredecessor(Event ev) {
		final AbstractEvent event = (AbstractEvent)ev;
		if (predecessor != null) {
			predecessor.successor = null;
		}
		if (event != null) {
			if (event.successor != null){
				event.successor.predecessor = null;
			}
			event.successor = this;
			event.setThread(this.thread);
		}
		predecessor = event;
	}

	@Override
	public final List<Event> getSuccessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add(cur);
			cur = cur.getSuccessor();
		}

		return events;
	}

	@Override
	public final List<Event> getPredecessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add(cur);
			cur = cur.getPredecessor();
		}

		return events;
	}


	@Override
	public void delete() {
		if (getPredecessor() != null) {
			getPredecessor().setSuccessor(this.getSuccessor());
		} else if (getSuccessor() != null) {
			this.getSuccessor().setPredecessor(null);
		}
	}

	@Override
	public void insertAfter(Event toBeInserted) {
		if (this.successor != null) {
			this.successor.setPredecessor(toBeInserted);
		}
		this.setSuccessor(toBeInserted);
	}

	@Override
	public void insertAfter(List<Event> toBeInserted) {
		Event cur = this;
		for (Event next : toBeInserted) {
			cur.insertAfter(next);
			cur = next;
		}
	}

	@Override
	public void replaceBy(Event replacement) {
		this.insertAfter(replacement);
		this.delete();
	}

	// ===============================================================================================

	// ======================================== Miscellaneous ========================================

	@Override
	public int compareTo(Event e){
		if (e == this) {
			return 0;
		}
		int result = Integer.compare(this.getGlobalId(), e.getGlobalId());
		if (result == 0) {
			final String error = String.format("Events %s and %s are different but have the same global id %d",
					this, e, e.getGlobalId());
			throw new IllegalStateException(error);
		}
		return result;
	}

	@Override
	public Event getCopy(){
		throw new UnsupportedOperationException("Copying is not allowed for " + getClass().getSimpleName());
	}

	@Override
	public void updateReferences(Map<Event, Event> updateMapping) { }

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitEvent(this);
	}

	@Override
	public void runLocalAnalysis(Program program, Context context) { }

	// This method needs to get overwritten for conditional events.
	@Override
	public boolean cfImpliesExec() {
		return true;
	}

	@Override
	public BooleanFormula encodeExec(EncodingContext ctx) {
		return ctx.getBooleanFormulaManager().makeTrue();
	}
}